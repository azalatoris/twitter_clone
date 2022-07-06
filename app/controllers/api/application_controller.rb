module Api
  class ApplicationController < ActionController::API
    rescue_from(ActiveRecord::RecordNotFound) { |error| render json: { errors: error.message }, status: :not_found }
  end
end