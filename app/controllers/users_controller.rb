class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc).page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    new_user = User.new(user_fields)
    if new_user.valid?
      new_user.save
      unless new_user.new_record?
        flash[:success] = [new_user.name + " successfully created"]
        session[:user_id] = new_user.id
        session[:admin] = new_user.admin
        session[:name] = new_user.name
        redirect_to '/'
        return
      else
        flash[:error] = ['Something went wrong with account creation']
        redirect_to "/users/new"
        return
      end
    end
    errors = []
    new_user.errors.messages.values.each { |errorArr| errorArr.each { |msg| errors.push(msg) }}
    flash[:error] = errors
    redirect_to '/login'
    return
  end

  def update
    user = User.find_by_id(params['id'])
    if logged_in_user = user || session[:admin]
      if user.update_attributes(user_fields)
        flash[:success] = ["User sucessfully updated!"]
      else
        flash[:error] = ["Something went wrong with the user update"]
      end
    else
      flash[:error] =["You are not authorized to change that user, contact an admin or log in as that user"]
    end
    redirect_to "/users/#{params['id']}"
    return
  end

  def show
    @user = User.includes(:reviews, comments: :review).find_by_id(params['id'])
    if( @user )
      render 'show'
    else
      flash[:error] = ["That user does not exist"]
      redirect_to '/'
      return
    end
  end

  def destroy
    user = User.find_by_id(params['id'])
    if (user == nil)
      flash[:error] = ["Can't find a user with that ID"]
      redirect_to '/'
      return
    end
    currentuser = logged_in_user
    if( user == currentuser || currentuser.admin )
      User.destroy(params['id'])
      unless User.exists?(id: params['id'])
        flash[:success] = ["#{ user.name }'s account has been successfully deleted, Goodbye!"]
        if(params['id'] == currentuser.id.to_s)
          redirect_to '/logout'
          return
        else
          redirect_to '/'
          return
        end
      else
        flash[:error] = ['Something went wrong with account deletion']
        redirect_to "/users/#{params['id']}"
        return
      end
    else
      flash[:error] =["You are not authorized to delete that account, contact an admin or log in as that user"]
    end
  end

  private
    def user_fields
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :bio, :admin, :pic_url)
    end
end
