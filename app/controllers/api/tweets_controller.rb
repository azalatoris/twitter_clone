module Api
  class TweetsController < Api::ApplicationController
    # before_action :set_tweet, only: %i[show update destroy]

    def index
      render json: Tweet.all
    end

    def show 
      render json: Tweet.find(params[:id])
    end
  end
end
