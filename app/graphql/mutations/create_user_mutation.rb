module Mutations
  class CreateUserMutation < GraphQL::Schema::Mutation
    argument :name, String, required: true
    argument :handle, String, required: true
    argument :email, String, required: true

    field :success, Boolean, null: false, description: "This field indicates if the mutation was resolved successfully"
    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(args)
      user = User.new(args)

      success = user.save
      errors = user.errors.full_messages
      {
        success: success,
        errors: errors,
        user: success ? user : nil
      }
    end

  end
end