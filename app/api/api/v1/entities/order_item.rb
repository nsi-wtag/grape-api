module V1
  module Entities
    class OrderItem
      expose :id
      expose :product, using: V1::Entities::Product
      expose :quantity
    end
  end
end
