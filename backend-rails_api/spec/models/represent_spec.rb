require 'rails_helper'

RSpec.describe Represent, type: :model do
  describe 'validations' do
    before do
      User.destroy_all
      User.create(
        id_user: 1,
        email: 'example1@ru.com',
        password: '12345678'
      )
    end
    it 'is valid with valid attributes' do
      represent = Represent.new(
        title: 'Example Represent',
        id_user: 1,
        active_quantities: [1, 2, 3]
      )
      expect(represent).to be_valid
    end

    it 'is not valid without a title' do
      represent = Represent.new(
        id_user: 1,
        active_quantities: [1, 2, 3]
      )
      expect(represent).to_not be_valid
    end

    it 'is not valid without an id_user' do
      represent = Represent.new(
        title: 'Example Represent',
        active_quantities: [1, 2, 3]
      )
      expect(represent).to_not be_valid
    end

    it 'is not valid without active_quantities' do
      represent = Represent.new(
        title: 'Example Represent',
        id_user: 1
      )
      expect(represent).to_not be_valid
    end

    it 'is not valid if active_quantities is not an array of integers' do
      represent = Represent.new(
        title: 'Example Represent',
        id_user: 1,
        active_quantities: ['string', 2, 3]
      )
      expect(represent).to_not be_valid
    end

    it 'is not valid if title is too long' do
      represent = Represent.new(
        title: 'a' * 101,
        id_user: 1,
        active_quantities: [1, 2, 3]
      )
      expect(represent).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many users as active_repr' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
    end
  end
end
