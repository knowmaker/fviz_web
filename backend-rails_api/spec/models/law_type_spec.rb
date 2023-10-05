# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LawType, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      law_type = LawType.new(
        type_name: 'Example Type',
        color: 'Example Color'
      )
      expect(law_type).to be_valid
    end

    it 'is not valid without type_name' do
      law_type = LawType.new(
        color: 'Example Color'
      )
      expect(law_type).to_not be_valid
    end

    it 'is not valid without color' do
      law_type = LawType.new(
        type_name: 'Example Type'
      )
      expect(law_type).to_not be_valid
    end

    it 'is not valid with too long type_name' do
      law_type = LawType.new(
        type_name: 'a' * 101,
        color: 'Example Color'
      )
      expect(law_type).to_not be_valid
    end

    it 'is not valid with too long color' do
      law_type = LawType.new(
        type_name: 'Example Type',
        color: 'a' * 51
      )
      expect(law_type).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many laws' do
      association = described_class.reflect_on_association(:laws)
      expect(association.macro).to eq :has_many
    end
  end
end
