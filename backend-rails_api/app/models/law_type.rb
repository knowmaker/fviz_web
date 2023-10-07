# frozen_string_literal: true

# Модель для хранения типов закономерностей
class LawType < ApplicationRecord
  self.table_name = 'law_types'

  has_many :laws, foreign_key: 'id_type'
  has_many :law_type_translations, foreign_key: 'id_type'
  translates :type_name, foreign_key: 'id_type', table_name: 'law_types_translations'

  validates :type_name, presence: true, length: { maximum: 100 }
  validates :color, presence: true, length: { maximum: 50 }
end
