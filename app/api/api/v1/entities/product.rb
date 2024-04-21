module V1
  module Entities
    class Product < Grape::Entity
      expose :id
      expose :name
      expose :description
      expose :price
    end
  end
end
