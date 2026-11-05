# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books, dependent: :restrict_with_error

  # The lab assignment suggests `order(active: true)`, but that only sorts rows.
  # `where` actually filters, so the scope returns active authors only.
  scope :active, -> { where(active: true) }

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name active]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
