# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Law, type: :model do
  describe 'validations' do
    before do
      LawType.destroy_all
      LawType.create(
        id_type: 1,
        type_name: 'Sample name',
        color: 'Red'
      )
      User.destroy_all
      User.create(
        id_user: 1,
        email: 'example1@ru.com',
        password: '12345678'
      )
      User.create(
        id_user: 2,
        email: 'example2@ru.com',
        password: '12345678'
      )
    end

    it 'is valid with valid attributes' do
      law = Law.new(
        law_name: 'Example Law',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1,
        id_type: 1
      )
      expect(law).to be_valid
    end

    it 'is not valid without law_name' do
      law = Law.new(
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1,
        id_type: 1
      )
      expect(law).to_not be_valid
    end

    it 'is not valid without first_element' do
      law = Law.new(
        law_name: 'Example Law',
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1,
        id_type: 1
      )
      expect(law).to_not be_valid
    end

    it 'is not valid without id_user' do
      law = Law.new(
        law_name: 'Example Law',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_type: 1
      )
      expect(law).to_not be_valid
    end

    it 'is valid without id_type' do
      law = Law.new(
        law_name: 'Example Law',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1
      )
      expect(law).to be_valid
    end

    it 'sets combination before create' do
      law = Law.create(
        law_name: 'Example Law',
        first_element: 4,
        second_element: 2,
        third_element: 3,
        fourth_element: 1,
        id_user: 1,
        id_type: 1
      )
      expect(law.combination).to eq([1, 2, 3, 4])
    end

    it 'is not valid with non-unique user and combination' do
      Law.create(
        law_name: 'Example Law 1',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1,
        id_type: 1
      )
      law = Law.new(
        law_name: 'Example Law 2',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1,
        id_type: 1
      )
      expect(law).to_not be_valid
    end

    it 'is valid with the same combination but different users' do
      Law.create(
        law_name: 'Example Law 1',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 1,
        id_type: 1
      )
      law = Law.new(
        law_name: 'Example Law 2',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_user: 2,
        id_type: 1
      )
      expect(law).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to law_type' do
      association = described_class.reflect_on_association(:law_type)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to first_element_quantity' do
      association = described_class.reflect_on_association(:first_element_quantity)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to second_element_quantity' do
      association = described_class.reflect_on_association(:second_element_quantity)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to third_element_quantity' do
      association = described_class.reflect_on_association(:third_element_quantity)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to fourth_element_quantity' do
      association = described_class.reflect_on_association(:fourth_element_quantity)
      expect(association.macro).to eq :belongs_to
    end
  end
end
