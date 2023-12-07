# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'represents', type: :request do
  path '/represents' do
    get('Get a list of represents') do
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
                       id_repr: { type: :integer, example: 1 },
                       title: { type: :string, maxLength: 100, example: "Базовое" }
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

    post('Create a new represent') do
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
              title: { type: :string, maxLength: 100, example: "Базовое" },
              active_quantities: {
                type: :array,
                minItems: 5,
                items: { type: :integer, example: 1 }
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
                     id_repr: { type: :integer, example: 1 },
                     title: { type: :string, maxLength: 100, example: "Базовое" },
                     id_user: { type: :integer, example: 1 },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: { type: :integer, example: 1}
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

  path '/represents/{id_repr}' do
    parameter name: 'id_repr', in: :path, type: :string, description: 'id_repr'

    get('Get the represent') do
      tags 'Represents'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer, example: 1 },
                     title: { type: :string, maxLength: 100, example: "Базовое" },
                     id_user: { type: :integer, example: 1 },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: { type: :integer, example: 1 }
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

    put('Update the represent') do
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
              title: { type: :string, maxLength: 100, example: "Базовое" },
              active_quantities: {
                type: :array,
                minItems: 5,
                items: { type: :integer, example: 1 }
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
                     id_repr: { type: :integer, example: 1 },
                     title: { type: :string, maxLength: 100, example: "Базовое" },
                     id_user: { type: :integer, example: 1 },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: { type: :integer, example: 1 }
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

    delete('Delete the represent') do
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

  path '/active_view' do
    get('Get active quantities for represent view') do
      tags 'Represents'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer, example: 1 },
                     title: { type: :string, maxLength: 100, example: "Базовое" },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: {
                         type: :object,
                         properties: {
                           id_value: { type: :integer, example: 1 },
                           value_name: { type: :string, maxLength: 200, example: "Скорость" },
                           symbol: { type: :string, maxLength: 100, example: "V" },
                           unit: { type: :string, maxLength: 100, example: "м/с" },
                           m_indicate_auto: { type: :integer, example: 5 },
                           l_indicate_auto: { type: :integer, example: 6 },
                           t_indicate_auto: { type: :integer, example: 7 },
                           i_indicate_auto: { type: :integer, example: 8 },
                           id_lt: { type: :integer, example: 1 },
                           id_gk: { type: :integer, example: 1 }
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

  path '/active_view/{id_repr}' do
    parameter name: 'id_repr', in: :path, type: :string, description: 'id_repr'

    get('Get active quantities for specific represent view') do
      tags 'Represents'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_repr: { type: :integer, example: 1 },
                     title: { type: :string, example: "Базовое" },
                     active_quantities: {
                       type: :array,
                       minItems: 5,
                       items: {
                         type: :object,
                         properties: {
                           id_value: { type: :integer, example: 1 },
                           value_name: { type: :string, maxLength: 200, example: "Скорость" },
                           symbol: { type: :string, maxLength: 100, example: "V" },
                           unit: { type: :string, maxLength: 100, example: "м/с" },
                           m_indicate_auto: { type: :integer, example: 5 },
                           l_indicate_auto: { type: :integer, example: 6 },
                           t_indicate_auto: { type: :integer, example: 7 },
                           i_indicate_auto: { type: :integer, example: 8 },
                           id_lt: { type: :integer, example: 1 },
                           id_gk: { type: :integer, example: 1 }
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
