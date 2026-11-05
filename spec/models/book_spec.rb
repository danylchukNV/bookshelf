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
