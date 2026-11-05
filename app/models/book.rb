# frozen_string_literal: true

class Book < ApplicationRecord
  include CoverUploader::Attachment(:cover)

  belongs_to :author, optional: true

  validates :title, presence: true
  validates :year, numericality: { only_integer: true, in: 1900..2030 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id title year author_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[author]
  end
end
