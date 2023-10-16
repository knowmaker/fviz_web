# frozen_string_literal: true

class LawTypeTranslation < ApplicationRecord
  self.table_name = 'law_types_translations'

  belongs_to :law_type, foreign_key: 'id_type'

  validates :type_name, length: { maximum: 100 }
end
