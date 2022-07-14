module Api
  class TweetsController < Api::ApplicationController
    def index
      @tweets = Tweet.all
      render json: @tweets, include: ''
    end

    def show 
      render json: Tweet.find(params[:id])
    end

    def create
      @tweet = Tweet.new(params.permit(:content, :user_id))
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: {errors: @tweet.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def update
      @tweet = Tweet.find(params[:id])
      @tweet.content = params[:content]
      if @tweet.save
        render json: @tweet
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @tweet = Tweet.find(params[:id])
      @tweet.destroy
      render json: @tweet
    end
  end
end
