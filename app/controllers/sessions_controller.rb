class SessionsController < ApplicationController

  def create
    if (user = User.find_by_email(params['email']))
      if user.try(:authenticate, params['password'])
        session[:user_id] = user.id
        session[:name] = user.name
        session[:admin] = user.admin
        redirect_to "/"
        return
      else
        flash[:error] = ["That password is incorrect"]
      end
    else
      flash[:error] = ["That email is not registered yet"]
    end
    redirect_to '/login'
  end
  def destroy
    session.delete(:user_id)
    session.delete(:admin)
    session.delete(:name)
    redirect_to '/'
  end
end
