# frozen_string_literal: true

# Модель для хранения слоев
class Gk < ApplicationRecord
  self.table_name = 'gk'

  has_many :gk_settings, foreign_key: 'id_gk'
  has_many :quantities, foreign_key: 'id_gk'

  validates :g_indicate, presence: true, numericality: { only_integer: true }
  validates :k_indicate, presence: true, numericality: { only_integer: true }
  validates :gk_name, length: { maximum: 100 }
  validates :gk_sign, length: { maximum: 50 }
  validates :color, presence: true, length: { maximum: 50 }
end
