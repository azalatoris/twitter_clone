module Api
  class UsersController < Api::ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      render json: User.all
    end

    def show
      render json: @user
    end

    def destroy
      @user.destroy
    end
  
    private

    def set_user 
      @user = User.find(params[:id])
    end
  end
end