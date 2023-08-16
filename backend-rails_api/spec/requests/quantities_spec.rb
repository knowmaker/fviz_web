require 'swagger_helper'

RSpec.describe 'quantities', type: :request do
  # Определение параметров, используемых в запросах
  let(:quantity_params) do
    {
      val_name: 'Sample Value',
      symbol: 'SV',
      M_indicate: 'M_value',
      L_indicate: 'L_value',
      T_indicate: 'T_value',
      I_indicate: 'I_value',
      unit: 'Unit',
      l_indicate: 'l_value',
      t_indicate: 't_value',
      g_indicate: 'g_value',
      k_indicate: 'k_value'
    }
  end

  path '/api/quantities' do
    post('create quantity') do
      tags 'Quantities'
      consumes 'application/json'
      parameter name: :quantity, in: :body, schema: {
        type: :object,
        properties: {
          val_name: { type: :string },
          symbol: { type: :string },
          M_indicate: { type: :integer },
          L_indicate: { type: :integer },
          T_indicate: { type: :integer },
          I_indicate: { type: :integer },
          unit: { type: :string },
          l_indicate: { type: :integer },
          t_indicate: { type: :integer },
          g_indicate: { type: :integer },
          k_indicate: { type: :integer }
        },
        required: ['val_name', 'symbol', 'M_indicate', 'L_indicate', 'T_indicate', 'I_indicate', 'unit',
                   'l_indicate', 't_indicate', 'g_indicate', 'k_indicate']
      }

      response(201, 'created') do
        let(:quantity) { quantity_params }

        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end

    get('list quantities') do
      tags 'Quantities'
      response(200, 'successful') do
        run_test!
      end

      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/quantities/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show quantity') do
      tags 'Quantities'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end

    put('update quantity') do
      tags 'Quantities'
      consumes 'application/json'
      parameter name: :quantity, in: :body, schema: {
        type: :object,
        properties: {
          val_name: { type: :string },
          symbol: { type: :string },
          M_indicate: { type: :integer },
          L_indicate: { type: :integer },
          T_indicate: { type: :integer },
          I_indicate: { type: :integer },
          unit: { type: :string },
          l_indicate: { type: :integer },
          t_indicate: { type: :integer },
          g_indicate: { type: :integer },
          k_indicate: { type: :integer }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }
        let(:quantity) { quantity_params }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end

    delete('delete quantity') do
      tags 'Quantities'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end
  end
end
