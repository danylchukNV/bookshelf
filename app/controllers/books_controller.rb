# frozen_string_literal: true

class BooksController < ApplicationController
  layout 'site'

  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.order(:id)
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

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.expect(book: %i[title author year description])
  end
end
