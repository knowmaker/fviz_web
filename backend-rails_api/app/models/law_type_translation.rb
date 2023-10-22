# frozen_string_literal: true

# Модель для хранения переводов типов закономерностей
class LawTypeTranslation < ApplicationRecord
  self.table_name = 'law_types_translations'

  belongs_to :law_type, foreign_key: 'id_type'

  validates :type_name, length: { maximum: 100 }
end
