# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'quantities', type: :request do
  path '/quantities' do
    get('Get a list of physical quantities') do
      tags 'Quantities'
      security [{ bearerAuth: [] }]
      produces 'application/pdf'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 file: { type: :string, format: :byte }
               }
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    post('Create a new physical quantity') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'Quantities'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :quantity, in: :body, schema: {
        type: :object,
        properties: {
          quantity: {
            type: :object,
            properties: {
              value_name: { type: :string, maxLength: 200, example: "Скорость" },
              symbol: { type: :string, maxLength: 100, example: "V" },
              unit: { type: :string, maxLength: 100, example: "м/с" },
              m_indicate_auto: { type: :integer, example: 5 },
              l_indicate_auto: { type: :integer, example: 6 },
              t_indicate_auto: { type: :integer, example: 7 },
              i_indicate_auto: { type: :integer, example: 8 },
              l_indicate: { type: :integer, example: 0 },
              t_indicate: { type: :integer, example: 0 },
              id_gk: { type: :integer, example: 1 }
            },
            required: %w[value_name symbol m_indicate_auto l_indicate_auto t_indicate_auto i_indicate_auto unit
                         l_indicate t_indicate id_gk]
          }
        }
      }

      response(201, 'created') do
        schema type: :object,
               properties: {
                 data:{
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
                     l_indicate: { type: :integer, example: 0 },
                     t_indicate: { type: :integer, example: 0 },
                     id_gk: { type: :integer, example: 1 },
                     g_indicate: { type: :integer, example: 0 },
                     k_indicate: { type: :integer, example: 0 },
                     color: { type: :string, maxLength: 100, example: "#FFFFFF" }
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

  path '/quantities/{id_value}' do
    parameter name: 'id_value', in: :path, type: :string, description: 'id_value'

    get('Get the physical quantity') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'Quantities'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
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
                     l_indicate: { type: :integer, example: 0 },
                     t_indicate: { type: :integer, example: 0 },
                     id_gk: { type: :integer, example: 1 },
                     g_indicate: { type: :integer, example: 0 },
                     k_indicate: { type: :integer, example: 0 },
                     color: { type: :string, maxLength: 100, example: "#FFFFFF" }
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

    put('Update the physical quantity') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'Quantities'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :quantity, in: :body, schema: {
        type: :object,
        properties: {
          quantity: {
            type: :object,
            properties: {
              value_name: { type: :string, maxLength: 200, example: "Скорость" },
              symbol: { type: :string, maxLength: 100, example: "V" },
              unit: { type: :string, maxLength: 100, example: "м/с" },
              m_indicate_auto: { type: :integer, example: 5 },
              l_indicate_auto: { type: :integer, example: 6 },
              t_indicate_auto: { type: :integer, example: 7 },
              i_indicate_auto: { type: :integer, example: 8 },
              l_indicate: { type: :integer, example: 0 },
              t_indicate: { type: :integer, example: 0 },
              id_gk: { type: :integer, example: 1 }
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
                     id_value: { type: :integer, example: 1 },
                     value_name: { type: :string, maxLength: 200, example: "Скорость" },
                     symbol: { type: :string, maxLength: 100, example: "V" },
                     unit: { type: :string, maxLength: 100, example: "м/с" },
                     m_indicate_auto: { type: :integer, example: 5 },
                     l_indicate_auto: { type: :integer, example: 6 },
                     t_indicate_auto: { type: :integer, example: 7 },
                     i_indicate_auto: { type: :integer, example: 8 },
                     id_lt: { type: :integer, example: 1 },
                     l_indicate: { type: :integer, example: 0 },
                     t_indicate: { type: :integer, example: 0 },
                     id_gk: { type: :integer, example: 1 },
                     g_indicate: { type: :integer, example: 0 },
                     k_indicate: { type: :integer, example: 0 },
                     color: { type: :string, maxLength: 100, example: "#FFFFFF" }
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

    delete('Delete the physical quantity') do
      tags 'Quantities'
      security [{ bearerAuth: [] }]

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

  path '/layers/{id_lt}' do
    parameter name: 'id_lt', in: :path, type: :string, description: 'id_lt'

    get('Get a file of physical quantities by lt id') do
      tags 'Quantities'
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
