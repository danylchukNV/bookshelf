# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "Author #{n}" }
    bio { 'Short biography' }
    active { true }

    trait :inactive do
      active { false }
    end
  end
end
