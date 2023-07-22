class Gk < ApplicationRecord
  self.table_name = "gk"

  has_many :gk_settings, foreign_key: "id_gk"
  has_many :quantities, foreign_key: "id_gk"
end
