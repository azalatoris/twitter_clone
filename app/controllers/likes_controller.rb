class LikesController < ApplicationController
  def index
    @likes = Like.all
  end

  def show
    @like = Like.find(params[:id])
  end

  def new
    @like = Like.new
  end

  def create
    @like = Like.new(params.require(:like).permit(:user_id, :tweet_id))
    if @like.save
      flash[:notice] = "Tweet was liked"
      redirect_to tweets_path
    else
      render tweets_path
    end
  end

  def update
  end

  def edit
    @like = Like.find(params[:id])
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_to tweets_path
  end
end
