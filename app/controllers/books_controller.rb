class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :set_book_category, only: [:index, :show]
  
  def search
    @books = Book.ransack(title_or_description_cont: params[:q]).result(distinct: true)
    
    respond_to do |format|
      format.js # actually means: if the client ask for js -> return file.js
    end
  end

  def index
    if @category.nil?
      @books = Book.all.order(created_at: :desc)
    else
      @books = Book.where(category_id: @category).order(created_at: :desc)
    end
  end

  def show
    if @book.reviews.blank?
      @average_review = 0
    else
      @average_review = @book.reviews.average(:rating).round(2)
    end

    ap 'rating'
    ap @average_review
  end

  def new
    @book = Book.new
    @categories = Category.all.map{ |c| [c.name, c.id] }  
  end

  def create
    @book = current_user.books.build(book_params)
    @book.category_id = params[:category_id]

    if @book.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.all.map{ |c| [c.name, c.id] }
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      render 'edit'
    end
  end

  def destroy
    if @book.destroy
      redirect_to root_path
    else
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :description, :author, :category_id, :book_img, tags_attributes: [:id, :name, :description, :_destroy])  
  end

  def find_book
    # params.require(:book).permit(:id)
    @book = Book.find(params['id'])
  end

  def set_book_category
    @category = Category.find_by(name: params[:category])
  end
end