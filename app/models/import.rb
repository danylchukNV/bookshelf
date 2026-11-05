# frozen_string_literal: true

# Result of one CSV import: who started it, how many books were created or skipped and how long it took.
class Import < ApplicationRecord
  STATUSES = %w[pending processing completed failed].freeze

  belongs_to :admin

  validates :filename, presence: true
  validates :status, inclusion: { in: STATUSES }

  STATUSES.each do |name|
    define_method(:"#{name}?") { status == name }
  end
end
