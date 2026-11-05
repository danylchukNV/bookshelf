# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    year { 2000 }
    description { 'Book description' }
    author
  end
end
