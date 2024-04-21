module V1
  module Resources
    class Users < Grape::API
      resource :users do
        desc 'Create a new user'
        params do
          requires :email, type: String
          requires :password, type: String
          optional :role, type: Integer
        end
        post do
          user = User.new(declared(params, include_missing: false))
  
          if user.save
            present user, with: V1::Entities::User
          else
            error!(user.errors.full_messages.join(', '), 400)
          end
        end
  
        desc 'Sign in a user'
        params do
          requires :email, type: String
          requires :password, type: String
        end
        post '/sign_in' do
          user = User.find_by(email: params[:email])
          if user&.authenticate(params[:password])
            token = JWT.encode({ user_id: user.id }, ENV['JWT_SECRET'])
            { token: token }
          else
            error!('Invalid email or password', 401)
          end
        end
      end
    end
  end
end
