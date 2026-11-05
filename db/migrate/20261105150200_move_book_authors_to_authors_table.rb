# frozen_string_literal: true

# Lab 2 stored the author as plain text in books.author.
# This migration creates an Author record for every distinct name,
# links books to it through author_id and drops the old text column.
#
# strong_migrations cannot inspect raw SQL, so the whole migration is
# wrapped in safety_assured: the books table is small and nothing else
# reads books.author any more.
class MoveBookAuthorsToAuthorsTable < ActiveRecord::Migration[8.0]
  def up
    safety_assured do
      execute <<~SQL.squish
        INSERT INTO authors (name, active, created_at, updated_at)
        SELECT DISTINCT books.author, TRUE, NOW(), NOW()
        FROM books
        WHERE books.author IS NOT NULL AND books.author <> ''
        ON CONFLICT (name) DO NOTHING
      SQL

      execute <<~SQL.squish
        UPDATE books SET author_id = authors.id
        FROM authors
        WHERE authors.name = books.author AND books.author_id IS NULL
      SQL

      remove_column :books, :author
    end
  end

  def down
    safety_assured do
      add_column :books, :author, :string

      execute <<~SQL.squish
        UPDATE books SET author = authors.name
        FROM authors
        WHERE authors.id = books.author_id
      SQL
    end
  end
end
