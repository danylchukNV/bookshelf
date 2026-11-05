# frozen_string_literal: true

class AuthorsController < ApplicationController
  layout 'site'

  before_action :set_author, only: %i[edit update destroy]

  def index
    @authors = Author.includes(:books).order(:name)
  end

  def new
    @author = Author.new
  end

  def edit; end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to authors_path, notice: "Author \"#{@author.name}\" was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      redirect_to authors_path, notice: "Author \"#{@author.name}\" was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @author.destroy
      redirect_to authors_path, notice: "Author \"#{@author.name}\" was successfully deleted.", status: :see_other
    else
      redirect_to authors_path, alert: @author.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.expect(author: %i[name bio active])
  end
end
