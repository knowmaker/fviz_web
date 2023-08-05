# frozen_string_literal: true

# Модель для хранения типов закономерностей
class LawType < ApplicationRecord
  self.table_name = 'laws_type'

  has_many :laws, foreign_key: 'id_type'
end
