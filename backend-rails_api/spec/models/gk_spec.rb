# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gk, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      gk = Gk.new(
        g_indicate: 10,
        k_indicate: 20,
        gk_name: 'Example Name',
        gk_sign: 'Example Sign',
        color: 'Red'
      )
      expect(gk).to be_valid
    end

    it 'is not valid without g_indicate' do
      gk = Gk.new(
        k_indicate: 20,
        gk_name: 'Example Name',
        gk_sign: 'Example Sign',
        color: 'Red'
      )
      expect(gk).to_not be_valid
    end

    it 'is not valid without k_indicate' do
      gk = Gk.new(
        g_indicate: 10,
        gk_name: 'Example Name',
        gk_sign: 'Example Sign',
        color: 'Red'
      )
      expect(gk).to_not be_valid
    end

    it 'is not valid with too long gk_name' do
      gk = Gk.new(
        g_indicate: 10,
        k_indicate: 20,
        gk_name: 'a' * 101,
        gk_sign: 'Example Sign',
        color: 'Red'
      )
      expect(gk).to_not be_valid
    end

    it 'is not valid with too long gk_sign' do
      gk = Gk.new(
        g_indicate: 10,
        k_indicate: 20,
        gk_name: 'Example Name',
        gk_sign: 'a' * 51,
        color: 'Red'
      )
      expect(gk).to_not be_valid
    end

    it 'is not valid without color' do
      gk = Gk.new(
        g_indicate: 10,
        k_indicate: 20,
        gk_name: 'Example Name',
        gk_sign: 'Example Sign'
      )
      expect(gk).to_not be_valid
    end

    it 'is not valid with too long color' do
      gk = Gk.new(
        g_indicate: 10,
        k_indicate: 20,
        gk_name: 'Example Name',
        gk_sign: 'Example Sign',
        color: 'a' * 51
      )
      expect(gk).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many quantities' do
      association = described_class.reflect_on_association(:quantities)
      expect(association.macro).to eq :has_many
    end
  end
end
