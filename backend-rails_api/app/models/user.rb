class User < ApplicationRecord
  self.table_name = "users"
  has_many :gk_settings
  has_many :represents
  has_many :laws
end
