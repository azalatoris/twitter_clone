class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def new
    @tweet = Tweet.new
    @user_options = User.pluck(:handle, :id)
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def create
    @user_options = User.pluck(:handle, :id)
    @tweet = Tweet.new(params.require(:tweet).permit(:content, :user_id))
    if @tweet.save
      flash[:notice] = "Tweet was created successfully"
      redirect_to @tweet
    else
      render 'new'
    end
  end

  def update
    if @tweet.update(params.require(:tweet).permit(:content, :user_id))
      redirect to @tweet
    else
      render 'edit'
    end
  end

  def destroy
    @tweet.destroy
    redirect_to tweets_path
  end
end