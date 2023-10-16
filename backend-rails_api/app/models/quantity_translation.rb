# frozen_string_literal: true

class QuantityTranslation < ApplicationRecord
  self.table_name = 'quantity_translations'

  belongs_to :quantity, foreign_key: 'id_value'

  validates :value_name, length: { maximum: 200 }
  validates :unit, length: { maximum: 100 }
end
