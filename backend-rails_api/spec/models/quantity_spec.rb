# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quantity, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to be_valid
    end

    it 'is not valid with too long value_name' do
      quantity = Quantity.new(
        value_name: 'a' * 201,
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid without m_indicate_auto' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid without l_indicate_auto' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid without t_indicate_auto' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid without i_indicate_auto' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid without id_lt' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid without id_gk' do
      quantity = Quantity.new(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1
      )
      expect(quantity).to_not be_valid
    end

    it 'is not valid when id_gk is not unique within the scope of id_lt' do
      Quantity.create(
        value_name: 'Example Value',
        symbol: 'E',
        m_indicate_auto: 10,
        l_indicate_auto: 20,
        t_indicate_auto: 30,
        i_indicate_auto: 40,
        unit: 'Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      quantity = Quantity.new(
        value_name: 'Another Example Value',
        symbol: 'AE',
        m_indicate_auto: 15,
        l_indicate_auto: 25,
        t_indicate_auto: 35,
        i_indicate_auto: 45,
        unit: 'Another Example Unit',
        id_lt: 1,
        id_gk: 1
      )
      expect(quantity).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to lt' do
      association = described_class.reflect_on_association(:lt)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to gk' do
      association = described_class.reflect_on_association(:gk)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many laws_as_first_element' do
      association = described_class.reflect_on_association(:laws_as_first_element)
      expect(association.macro).to eq :has_many
    end

    it 'has many laws_as_second_element' do
      association = described_class.reflect_on_association(:laws_as_second_element)
      expect(association.macro).to eq :has_many
    end

    it 'has many laws_as_third_element' do
      association = described_class.reflect_on_association(:laws_as_third_element)
      expect(association.macro).to eq :has_many
    end

    it 'has many laws_as_fourth_element' do
      association = described_class.reflect_on_association(:laws_as_fourth_element)
      expect(association.macro).to eq :has_many
    end
  end
end
