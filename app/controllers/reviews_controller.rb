class ReviewsController < ApplicationController
  def home
  end

  def index
    @reviews = Review.includes(:user).order(comments_count: :desc).limit(10)
    @comments = Comment.includes(:user).order(created_at: :desc).limit(10)
  end

  def all
    @reviews = Review.includes(:user).order(created_at: :desc).page params[:page]
  end

  def new
    if session[:user_id]
      @review = Review.new
      render 'new'
    else
      redirect_to '/login'
    end
  end

  def create
    new_review = Review.new(review_fields)
    new_review.user = User.find_by_id(session[:user_id])
    if session[:user_id] && new_review.valid?
      new_review.save
      unless new_review.new_record?
        flash[:success] = ["Review successfully posted!"]
        redirect_to "/reviews/#{new_review.id}"
        return
      else
        flash[:error] = ["Something went wrong with review creation"]
        redirect_to "/reviews/new"
        return
      end
    end
    errors = []
    new_review.errors.messages.values.each { |errorArr| errorArr.each { |msg| errors.push(msg) }}
    flash[:error] = errors
    redirect_to '/reviews/new'
  end

  def show
    if  @review = Review.includes(:user, comments: [:user]).find_by_id(params['id'])
      @comments = @review.comments.page params[:page]
      @comment = Comment.new
    else
      flash[:error] = ['That review does not exist']
      redirect_to '/reviews'
      return
    end
  end

  def edit
    @review = Review.find_by_id(params['id'])
    unless logged_in_user == @review.user || session[:admin]
      flash[:error] = ["You are not authorized to change that review, contact an admin or log in as that review's user"]
      redirect_to "/reviews/#{params['id']}"
      return
    end
  end

  def update
    review = Review.find_by_id(params['id'])
    if logged_in_user = review.user || session[:admin]
      if review.update_attributes(review_fields)
        flash[:success] = ["Review sucessfully updated!"]
      else
        flash[:error] = ["Something went wrong with the review update"]
      end
    else
      flash[:error] =["You are not authorized to change that review, contact an admin or log in as that review's user"]
    end
    redirect_to "/reviews/#{params['id']}"
  end

  def destroy
    review = Review.includes(:user).find_by_id(params['id'])
    if (review == nil)
      flash[:error] = ["Can't find a review with that ID"]
      redirect_to '/'
      return
    end
    if( review.user == logged_in_user || session[:admin] )
      Review.destroy(params['id'])
      unless Review.exists?(id: params['id'])
        unless review.title == '' || review.title == nil
          flash[:success] = ["\"#{review.title}\" review has been deleted"]
        else
          flash[:success] = ["\"#{review.subject}\" review has been deleted"]
        end
        redirect_to '/'
        return
      else
        flash[:error] = ['Something went wrong with review deletion']
      end
    else
      flash[:error] =["You are not authorized to delete that review, contact an admin or log in as that review's user"]
    end
    redirect_to "/reviews/#{review.id}"
    return
  end

  private
    def review_fields
      params.require(:review).permit(:title, :genre, :media, :title, :subject, :content, :pic_url)
    end
end
