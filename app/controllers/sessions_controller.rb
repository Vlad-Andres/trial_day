class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user
      if user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        redirect_to todos_path
      else 
        flash.now[:danger] = 'Bad name/password combination. '
        render 'new'
      end
    end
  end

  def delete
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_path
  end
end
