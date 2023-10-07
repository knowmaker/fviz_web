# frozen_string_literal: true

# Модель для хранения ячеек
class Lt < ApplicationRecord
  self.table_name = 'lt'

  has_many :quantities, foreign_key: 'id_lt'

  validates :l_indicate, presence: true, numericality: { only_integer: true }
  validates :t_indicate, presence: true, numericality: { only_integer: true }
end
