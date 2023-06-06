class Law < ApplicationRecord
  self.table_name = "laws"
  alias_attribute :user_id, :id_user
  alias_attribute :type_id, :id_type
  belongs_to :user
  belongs_to :law_type
  belongs_to :quantity
end
