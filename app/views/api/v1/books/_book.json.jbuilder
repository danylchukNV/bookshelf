# frozen_string_literal: true

json.extract! book, :id, :title, :year, :description

if book.author
  json.author do
    json.extract! book.author, :id, :name
  end
else
  json.author nil
end

json.extract! book, :created_at, :updated_at
