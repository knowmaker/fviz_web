# frozen_string_literal: true

class GkTranslation < ApplicationRecord
  self.table_name = 'gk_translations'

  belongs_to :gk, foreign_key: 'id_gk'

  validates :gk_name, length: { maximum: 100 }
end
