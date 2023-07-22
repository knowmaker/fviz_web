class Represent < ApplicationRecord
  self.table_name = "represents"

  belongs_to :user, foreign_key: "id_user"
end
