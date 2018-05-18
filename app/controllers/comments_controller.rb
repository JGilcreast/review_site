class CommentsController < ApplicationController

  def create
    if session[:user_id]
      new_comment = Comment.new(comment_fields)
      new_comment.user = User.find_by_id(session[:user_id])
      new_comment.review = Review.find_by_id(params['id'])
      if new_comment.valid?
        new_comment.save
        flash[:success] = ["Comment successfully posted!"]
        redirect_to "/reviews/#{params['id']}"
        return
      else
        errors=[]
        new_comment.errors.messages.values.each { |errorArr| errorArr.each { |msg| errors.push(msg) }}
        flash[:errors] = errors;
      end
    else
      flash[:errors] = ['You must be logged in to post a comment!'];
    end
    redirect_to "/reviews/#{params['id']}"
    return
  end

  def destroy
    comment = Comment.find_by_id(params['comment_id'])
    if (comment == nil)
      flash[:error] = ["Can't find a comment with that ID"]
      redirect_to '/'
      return
    end
    if (session[:user_id] == comment.user.id) or (session[:admin] == true)
      comment.destroy
      flash[:success] = ["Comment successfully deleted!"]
    else
      flash[:error] = ["You cannot delete someone else's comment, log in as the comment's user ot contact an admin to delete it"]
    end
    redirect_to "/reviews/#{params['id']}"
  end

  private
    def comment_fields
      params.require(:comment).permit(:content)
    end
end
