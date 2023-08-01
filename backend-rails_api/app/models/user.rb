class User < ApplicationRecord
  # has_secure_password

  self.table_name = "users"
  has_many :gk_settings, foreign_key: "id_user"
  has_many :laws, foreign_key: "id_user"
  has_many :represents, foreign_key: "id_user"
end
