class TextsController < ApplicationController
  before_action :require_admin, only: [:admin, :create]
  
  def index
    @texts = Text.all.to_a
  end
  
  def admin
    @text = Text.new
  end

  def create
    @text = Text.new(text_params)
    if @text.save
      redirect_to texts_path
    else
      render :admin
    end
  end

  private

  def text_params
    params.require(:text).permit(:title, :content, :language, :period)
  end

  def require_admin
    unless current_admin?
      flash[:error] = "Доступ запрещён"
      redirect_to login_path
    end
  end

  def current_admin
    @current_admin ||= AdminUser.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_admin.present?
  end

end
