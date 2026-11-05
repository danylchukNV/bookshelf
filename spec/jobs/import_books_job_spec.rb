# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportBooksJob, type: :job do
  let(:admin) { create(:admin) }
  let(:import) { create(:import, admin: admin) }
  let(:author) { create(:author, name: 'Леся Українка') }

  before { ActionMailer::Base.deliveries.clear }

  def run(csv)
    described_class.perform_now(import.id, csv)
    import.reload
  end

  it 'creates books for existing authors and skips unknown ones' do
    author
    run(<<~CSV)
      title,author_name,year,description
      Лісова пісня,леся українка,1911,Драма
      Кобзар,Тарас Шевченко,1840,Unknown author
    CSV

    expect(import).to be_completed
    expect(import.created_count).to eq(1)
    expect(import.skipped_count).to eq(1)
    expect(import.skipped_rows.first['reason']).to include('not found')
    expect(author.books.pluck(:title)).to eq(['Лісова пісня'])
    expect(import.duration_seconds).to be >= 0
  end

  it 'skips duplicates and invalid rows' do
    create(:book, author: author, title: 'Лісова пісня')
    run(<<~CSV)
      title,author_name,year,description
      Лісова пісня,Леся Українка,1911,Duplicate
      Нова книга,Леся Українка,1850,Bad year
    CSV

    expect(import.created_count).to eq(0)
    expect(import.skipped_rows.pluck('reason')).to contain_exactly('Book already exists', a_string_including('Year'))
  end

  it 'fails when required columns are missing' do
    run("name,year\nX,2000\n")
    expect(import).to be_failed
    expect(import.error_message).to include('author_name')
  end

  it 'sends the report e-mail to the admin' do
    run("title,author_name\n")
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq([admin.email])
    expect(mail.subject).to include("##{import.id}")
  end
end
