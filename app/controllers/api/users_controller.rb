module Api
  class UsersController < Api::ApplicationController
  def index
    @users = User.all
    render json: @users, include: ''
  end

    def show
      render json: User.find(params[:id])
    end

    def create
      user = User.create(params.permit(:name, :handle, :bio, :email))
      if user.save
        render json: user, status: :created
      else
        render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      render json: user
    end
  end
end