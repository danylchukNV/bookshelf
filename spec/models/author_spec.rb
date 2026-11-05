# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  subject(:author) { create(:author) }

  it { is_expected.to have_many(:books).dependent(:restrict_with_error) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '.active' do
    it 'returns only active authors' do
      active = create(:author)
      inactive = create(:author, :inactive)

      expect(described_class.active).to include(active)
      expect(described_class.active).not_to include(inactive)
    end
  end

  describe '#destroy' do
    it 'is not allowed while the author has books' do
      create(:book, author:)

      expect(author.destroy).to be(false)
      expect(author.errors.full_messages).to include('Cannot delete record because dependent books exist')
      expect(described_class.exists?(author.id)).to be(true)
    end
  end
end
