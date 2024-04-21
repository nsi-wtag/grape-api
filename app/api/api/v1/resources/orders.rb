module V1
  module Resources
    class Orders < Grape::API
      resource :orders do
        desc 'Get all orders'
        get do
          orders = Order.all
          present orders, with: V1::Entities::Order
        end

        desc 'Get a specific order'
        route_param :id do
          get do
            order = Order.find(params[:id])
            present order, with: V1::Entities::Order
          end
        end

        desc 'Create a new order'
        params do
          requires :products, type: Array do
            requires :product_id, type: Integer
            requires :quantity, type: Integer
          end
        end
        post do
          order = Order.new(user: current_user)
          order.order_items = params[:products].map do |product_params|
            product = Product.find(product_params[:product_id])
            quantity = Product.find(product_params[:quantity])
            OrderItem.new(product: product, quantity: quantity)
          end

          if order.save
            present order, with: V1::Entities::Order
          else
            error!(order.errors.full_messages.join(', '), 400)
          end
        end

        desc 'Update an order'
        params do
          requires :id, type: Integer
          optional :products, type: Array do
            requires :product_id, type: Integer
            requires :quantity, type: Integer
          end
        end
        put '/:id' do
          order = Order.find(params[:id])
          if params[:products].present?
            order.order_items = params[:products].map do |product_params|
              product = Product.find(product_params[:product_id])
              quantity = Product.find(product_params[:quantity])
              OrderItem.new(product: product, quantity: quantity)
            end
          end

          if order.save
            present order, with: V1::Entities::Order
          else
            error!(order.errors.full_messages.join(", "), 400)
          end
        end

        desc 'Delete an order'
        params do
          requires :id, type: Integer
        end
        delete ':/id' do
          order = Order.find(params[:id])
          order.destroy
          body false
        end
      end
    end
  end
end
