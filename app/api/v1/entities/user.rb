module V1
  module Entities
    class User < Grape::Entity
      expose :id
      expose :email
      expose :role
    end
  end
end
