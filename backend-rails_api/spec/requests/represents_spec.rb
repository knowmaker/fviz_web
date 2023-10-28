# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'represents', type: :request do
  path '/api/represents' do
    get('list represents') do
      tags 'Represents'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   minItems: 5,
                   items: {
                     type: :object,
                     properties: {
                       id_repr: { type: :integer },
                       title: { type: :string }
                     }
                   }
                 }
               }
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    post('create represent') do
      tags 'Represents'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :represent, in: :body, schema: {
        type: :object,
        properties: {
          represent: {
            type: :object,
            properties: {
              title: { type: :string },
              active_quantities: {
                type: :array,
                minItems: 5,
                items: { type: :integer }
              }
            },
            required: %w[title active_quantities]
          }
        }
      }

      response(201, 'created') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer },
                     title: { type: :string },
                     id_user: { type: :integer },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: { type: :integer }
                     }
                   }
                 }
               }
        run_test!
      end
      response(422, 'unprocessable entity') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/represents/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show represent') do
      tags 'Represents'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer },
                     title: { type: :string },
                     id_user: { type: :integer },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: { type: :integer }
                     }
                   }
                 }
               }
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    put('update represent') do
      security [{ bearerAuth: [] }]
      tags 'Represents'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :represent, in: :body, schema: {
        type: :object,
        properties: {
          represent: {
            type: :object,
            properties: {
              title: { type: :string },
              active_quantities: {
                type: :array,
                minItems: 5,
                items: { type: :integer }
              }
            }
          }
        }
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer },
                     title: { type: :string },
                     id_user: { type: :integer },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: { type: :integer }
                     }
                   }
                 }
               }
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(422, 'unprocessable entity') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    delete('delete represent') do
      tags 'Represents'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/active_view' do
    get('get active quantities for represent view') do
      tags 'Represents'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer },
                     title: { type: :string },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: {
                         type: :object,
                         properties: {
                           id_value: { type: :integer },
                           value_name: { type: :string },
                           symbol: { type: :string },
                           unit: { type: :string },
                           m_indicate_auto: { type: :integer },
                           l_indicate_auto: { type: :integer },
                           t_indicate_auto: { type: :integer },
                           i_indicate_auto: { type: :integer },
                           id_lt: { type: :integer },
                           id_gk: { type: :integer }
                         }
                       }
                     }
                   }
                 }
               }
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/active_view/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get active quantities for specific represent view') do
      tags 'Represents'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer },
                     title: { type: :string },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: {
                         type: :object,
                         properties: {
                           id_value: { type: :integer },
                           value_name: { type: :string },
                           symbol: { type: :string },
                           unit: { type: :string },
                           m_indicate_auto: { type: :integer },
                           l_indicate_auto: { type: :integer },
                           t_indicate_auto: { type: :integer },
                           i_indicate_auto: { type: :integer },
                           id_lt: { type: :integer },
                           id_gk: { type: :integer }
                         }
                       }
                     }
                   }
                 }
               }
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end
end
