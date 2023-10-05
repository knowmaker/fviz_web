# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lt, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      lt = Lt.new(
        l_indicate: 10,
        t_indicate: 20,
        lt_sign: 'Example Sign'
      )
      expect(lt).to be_valid
    end

    it 'is not valid without l_indicate' do
      lt = Lt.new(
        t_indicate: 20,
        lt_sign: 'Example Sign'
      )
      expect(lt).to_not be_valid
    end

    it 'is not valid without t_indicate' do
      lt = Lt.new(
        l_indicate: 10,
        lt_sign: 'Example Sign'
      )
      expect(lt).to_not be_valid
    end

    it 'is not valid if l_indicate is not an integer' do
      lt = Lt.new(
        l_indicate: 'invalid',
        t_indicate: 20,
        lt_sign: 'Example Sign'
      )
      expect(lt).to_not be_valid
    end

    it 'is not valid if t_indicate is not an integer' do
      lt = Lt.new(
        l_indicate: 10,
        t_indicate: 'invalid',
        lt_sign: 'Example Sign'
      )
      expect(lt).to_not be_valid
    end

    it 'is not valid if lt_sign is too long' do
      lt = Lt.new(
        l_indicate: 10,
        t_indicate: 20,
        lt_sign: 'a' * 51
      )
      expect(lt).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many quantities' do
      association = described_class.reflect_on_association(:quantities)
      expect(association.macro).to eq :has_many
    end
  end
end
