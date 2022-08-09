class TwitterSchema < GraphQL::Schema
  query Types::QueryType
  mutation Mutations::MutationType
end