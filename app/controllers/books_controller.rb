# frozen_string_literal: true

class BooksController < ApplicationController
  layout 'site'

  before_action :set_book, only: %i[show edit update destroy]

  helper_method :author_options

  def index
    @q = Book.ransack(params[:q])
    @q.sorts = 'id asc' if @q.sorts.empty?
    @books = @q.result.includes(:author)
    @authors = Author.order(:name)
  end

  def show; end

  def new
    @book = Book.new
  end

  def edit; end

  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to books_path, notice: "Book \"#{@book.title}\" was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      redirect_to books_path, notice: "Book \"#{@book.title}\" was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy!
    redirect_to books_path, notice: "Book \"#{@book.title}\" was successfully deleted.", status: :see_other
  end

  private

  # Only active authors can be chosen. The book's current author is kept in the list
  # even if they became inactive, so editing the book does not silently drop them.
  def author_options
    Author.active.or(Author.where(id: @book&.author_id)).order(:name)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  # Only a signed-in admin may upload or remove a cover.
  def book_params
    permitted = %i[title author_id year description]
    permitted += %i[cover remove_cover] if admin_signed_in?
    params.expect(book: permitted)
  end
end
