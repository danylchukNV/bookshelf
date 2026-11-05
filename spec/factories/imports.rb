# frozen_string_literal: true

FactoryBot.define do
  factory :import do
    admin
    filename { 'books.csv' }
    status { 'pending' }
  end
end
