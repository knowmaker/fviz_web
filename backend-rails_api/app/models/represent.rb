class Represent < ApplicationRecord
  self.table_name = "represents"
  alias_attribute :user_id, :id_user
  belongs_to :user
end
