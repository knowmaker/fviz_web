# frozen_string_literal: true

# Модель для хранения переводов системных уровней
class GkTranslation < ApplicationRecord
  self.table_name = 'gk_translations'

  belongs_to :gk, foreign_key: 'id_gk'

  validates :gk_name, length: { maximum: 100 }
end
