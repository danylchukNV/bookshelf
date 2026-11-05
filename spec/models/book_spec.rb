# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { build(:book) }

  it { is_expected.to belong_to(:author).optional }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_numericality_of(:year).only_integer }

  it 'is valid with a year inside 1900..2030' do
    book.year = 1900
    expect(book).to be_valid
    book.year = 2030
    expect(book).to be_valid
  end

  it 'is invalid with a year outside 1900..2030' do
    book.year = 1899
    expect(book).not_to be_valid
    book.year = 2031
    expect(book).not_to be_valid
  end
end

RSpec.describe Book, 'cover', type: :model do
  let(:book) { build(:book) }

  it 'attaches an image through Shrine' do
    book.cover = Rails.root.join('spec/fixtures/files/cover.png').open
    expect(book).to be_valid
    book.save!
    expect(book.reload.cover.mime_type).to eq('image/png')
    expect(book.cover_data).to include('storage' => 'store')
  end

  it 'rejects a file that is not an image' do
    book.cover = Rails.root.join('spec/fixtures/files/not_image.txt').open
    expect(book).not_to be_valid
    expect(book.errors[:cover]).to be_present
  end
end
