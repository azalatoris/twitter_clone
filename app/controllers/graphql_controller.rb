class GraphqlController < ActionController::API
  def graphql
    render json: TwitterSchema.execute(params[:query], variables: params[:variables])
  end
end