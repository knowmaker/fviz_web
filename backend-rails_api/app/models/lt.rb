class Lt < ApplicationRecord
  self.table_name = "lt"
  has_many :quantities
end
