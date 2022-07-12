module Api
  class TweetsController < Api::ApplicationController
    # before_action :set_tweet, only: %i[show update destroy]

    def index
      render json: Tweet.all, include: ''
    end

    def show 
      render json: Tweet.find(params[:id])
    end

    def create
      tweet = Tweet.new(params.permit(:content, :user_id))
      if tweet.save
        render json: tweet, status: :created
      else
        render json: {errors: tweet.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end
end
