class Base < Grape::API
  mount V1::Resources::Users
  mount V1::Resources::Products
  mount V1::Resources::Orders
end
