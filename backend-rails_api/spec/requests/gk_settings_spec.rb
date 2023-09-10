require 'swagger_helper'

RSpec.describe 'gk_settings', type: :request do
  let(:gk_setting_params) do
    { gk_setting:
        {
          id_gk: 5,
          id_user: 2,
          gk_bright: '#fff'
        }
    }
  end

  path '/api/gk_settings' do
    get('list gk settings') do
      tags 'GK settings'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/gk_settings/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show GK setting') do
      tags 'GK settings'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end

    patch('update GK setting') do
      tags 'GK settings'
      consumes 'application/json'
      parameter name: :gk_setting, in: :body, schema: {
        type: :object,
        properties: {
          gk_setting: {
            type: :object,
            properties: {
              gk_bright: { type: :string }
            }
          }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }
        let(:gk_setting) { gk_setting_params }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end
  end
end
