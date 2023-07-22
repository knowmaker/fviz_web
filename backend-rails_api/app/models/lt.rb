class Lt < ApplicationRecord
  self.table_name = "lt"

  has_many :quantities, foreign_key: "id_lt"
end
