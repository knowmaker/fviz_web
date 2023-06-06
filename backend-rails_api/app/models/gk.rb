class Gk < ApplicationRecord
  self.table_name = "gk"
  has_many :quantities
  has_many :gk_settings
end
