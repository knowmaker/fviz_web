class LawType < ApplicationRecord
  self.table_name = "laws_type"
  has_many :laws
end
