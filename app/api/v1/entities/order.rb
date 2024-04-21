module V1
  module Entities
    class Order < Grape::Entity
      expose :id
      expose :user, using: V1::Entities::User
      exposer :total
    end
  end
end
