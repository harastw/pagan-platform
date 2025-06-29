class SessionsController < ApplicationController
  def new
      
  end

  def create
    user = AdminUser.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_texts_path
    else
      flash.now[:error] = "Неправильный логин или пароль"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
