# frozen_string_literal: true

class AddCoverDataToBooks < ActiveRecord::Migration[8.0]
  def change
    # Shrine keeps information about the attached file (id, storage, metadata) in one JSON column
    add_column :books, :cover_data, :jsonb
  end
end
