class GkTranslation < ApplicationRecord
  self.table_name = 'gk_translations'

  belongs_to :gk, class_name:  'Gk', foreign_key: 'id_gk'

  # validates :gk_name, length: { maximum: 100 }
end
