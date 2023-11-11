# frozen_string_literal: true

# Модель для хранения переводов физических величин
class QuantityTranslation < ApplicationRecord
  self.table_name = 'quantity_translations'

  belongs_to :quantity, foreign_key: 'id_value'
end
