# frozen_string_literal: true

class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.references :admin, null: false, foreign_key: true
      t.string :filename, null: false
      t.string :status, null: false, default: 'pending'
      t.integer :total_rows, null: false, default: 0
      t.integer :created_count, null: false, default: 0
      t.integer :skipped_count, null: false, default: 0
      t.jsonb :skipped_rows, null: false, default: []
      t.string :error_message
      t.datetime :started_at
      t.datetime :finished_at
      t.float :duration_seconds

      t.timestamps
    end
  end
end
