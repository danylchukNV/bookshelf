# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.text :bio
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :authors, :name, unique: true
  end
end
