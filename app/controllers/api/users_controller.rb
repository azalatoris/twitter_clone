module Api
  class UsersController < Api::ApplicationController
    def index
      render json: User.all
    end

    def show
      render json: User.find(params[:id])
    end
  end
end