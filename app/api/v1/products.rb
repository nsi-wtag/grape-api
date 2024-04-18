module API
  module V1
    class Products < Grape::API
      resource :products do
        desc 'Get all products'
        get do
          products = Products.all
          present products, with: APIEntities::Product
        end

        desc 'Get a specific product'
        route_param :id do
          get do
            product = Product.find(params[:id])
            present product, with: APIEntities::Product
          end
        end

        desc 'Create a new product'
        params do
          requires :name, type: String
          requires :description, type: String
          requires :price, type: Float
        end
        post do
          product = Product.new(declared(params, include_missing: false))
          if product.save
            present product, with: APIEntities::Product
          else
            error!(product.errors.full_messages.join(', '), 400)
          end
        end

        desc 'Update a product'
        params do
          requires :id, type: Integer
        end
        put '/:id' do
          product = Product.find(params[:id])
          if product.update(declared(params, include_missing: false))
            present product, with: APIEntities::Product
          else
            error!(product.errors.full_messages.join(', '), 400)
          end
        end

        desc 'Delete a product'
        params do
          requires :id, type: Integer
        end
        delete '/:id' do
          product = Product.find(params[:id])
          product.destroy
          body false
        end
      end
    end
  end
end
