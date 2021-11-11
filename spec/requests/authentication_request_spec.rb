require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  before(:each) do
    user = User.create(name: "User1",
                       email: "user1@example.com",
                       password: '123456',
                       password_confirmation: '123456')
  end

  path '/api/v1/login' do

    post 'Authenticates an existing user' do
      tags 'Authentication'
      description 'Returns a bearer token for '
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        email: { type: :string },
                        password: { type: :string },
                      }
                    },
                    required: %w[ email password ]
                  },
                  required: [ 'user' ]
                }
      response '201', 'blog created' do
        let(:user) {
          User.create(name: 'user1',
                      email: 'user1@example.com',
                      password: '123456',
                      password_confirmation: '12345')
        }
        let (:params) { { user: {
                            email: user.email,
                            password: user.password
                          } } }

        examples 'application/json' => { user: {
                                           email: 'user1@example.com',
                                           password: '123456'
                                         } }
        run_test!
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

      end

      response '422', 'invalid request' do
        let (:params) {{}}

        after do |example|
          example.metadata[:response][:examples] =
            { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
