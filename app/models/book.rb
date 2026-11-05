# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :year, numericality: { only_integer: true, in: 1900..2030 }
end
