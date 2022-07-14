module Api
  class LikesController < Api::ApplicationController
    def index
      @likes = Like.all
      render json: @likes
    end

    def show
      @like = Like.find(params[:id])
      render json: @like
    end

    def create
      @like = Like.new(params.permit(:user_id, :tweet_id))
      if @like.save
        render json: @like, status: :created
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @like = Like.find(params[:id])
      @like.destroy
      render json: @like
    end
  end
end