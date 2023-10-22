# frozen_string_literal: true

# Модель для хранения системных уровней
class Gk < ApplicationRecord
  self.table_name = 'gk'

  has_many :quantities, foreign_key: 'id_gk'
  has_many :gk_translations, foreign_key: 'id_gk'
  translates :gk_name, foreign_key: 'id_gk', table_name: 'gk_translations', fallbacks_for_empty_translations: true

  validates :g_indicate, presence: true, numericality: { only_integer: true }
  validates :k_indicate, presence: true, numericality: { only_integer: true }
  validates :gk_name, length: { maximum: 100 }
  validates :color, presence: true, length: { maximum: 50 }
end
