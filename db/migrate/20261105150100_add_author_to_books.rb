# frozen_string_literal: true

class AddAuthorToBooks < ActiveRecord::Migration[8.0]
  def change
    # strong_migrations warns that a regular index and foreign key lock the table.
    # The books table is small, so the simple form is safe here.
    safety_assured do
      add_reference :books, :author, index: true, foreign_key: true
    end
  end
end
