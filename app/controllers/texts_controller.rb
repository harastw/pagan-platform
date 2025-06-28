class TextsController < ApplicationController

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

end
