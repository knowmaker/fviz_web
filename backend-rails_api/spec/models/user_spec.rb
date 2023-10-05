# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        email: 'user@example.com',
        password: 'password123'
      )
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = User.new(password: 'password123')
      expect(user).to_not be_valid
    end

    it 'is not valid with invalid email format' do
      user = User.new(email: 'invalid_email')
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user = User.new(email: 'user@example.com')
      expect(user).to_not be_valid
    end

    it 'is not valid with a short password' do
      user = User.new(email: 'user@example.com', password: 'short')
      expect(user).to_not be_valid
    end

    it 'is valid without a last name' do
      user = User.new(email: 'user@example.com', password: 'password123', first_name: 'John')
      expect(user).to be_valid
    end

    it 'is valid without a patronymic' do
      user = User.new(email: 'user@example.com', password: 'password123', last_name: 'Doe', first_name: 'John')
      expect(user).to be_valid
    end

    it 'is valid with role set to true' do
      user = User.new(email: 'user@example.com', password: 'password123', role: true)
      expect(user).to be_valid
    end

    it 'is valid with role set to false' do
      user = User.new(email: 'user@example.com', password: 'password123', role: false)
      expect(user).to be_valid
    end

    it 'is not valid with role set to nil' do
      user = User.new(email: 'user@example.com', password: 'password123', role: nil)
      expect(user).to_not be_valid
    end

    it 'is valid with confirmed set to true' do
      user = User.new(email: 'user@example.com', password: 'password123', confirmed: true)
      expect(user).to be_valid
    end

    it 'is valid with confirmed set to false' do
      user = User.new(email: 'user@example.com', password: 'password123', confirmed: false)
      expect(user).to be_valid
    end

    it 'is not valid with confirmed set to nil' do
      user = User.new(email: 'user@example.com', password: 'password123', confirmed: nil)
      expect(user).to_not be_valid
    end

    it 'is valid with active_repr set to nil' do
      user = User.new(email: 'user@example.com', password: 'password123', active_repr: nil)
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    it 'has many laws' do
      association = described_class.reflect_on_association(:laws)
      expect(association.macro).to eq :has_many
    end

    it 'has many represents' do
      association = described_class.reflect_on_association(:represents)
      expect(association.macro).to eq :has_many
    end

    it 'belongs to represent' do
      association = described_class.reflect_on_association(:represent)
      expect(association.macro).to eq :belongs_to
    end
  end
end
