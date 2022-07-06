module Api
  class UsersController < Api::ApplicationController

  def index
      render json: User.all, include: ''
    end

    def show
      render json: User.find(params[:id])
    end

    def create
      user = User.new(params.permit(:name, :handle, :bio, :email))
      if user.save
        render json: user, status: :created
      else
        render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
    end
  
  end
end