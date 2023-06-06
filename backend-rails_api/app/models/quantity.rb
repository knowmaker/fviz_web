class Quantity < ApplicationRecord
  self.table_name = "quantity"
  alias_attribute :lt_id, :id_lt
  alias_attribute :gk_id, :id_gk
  belongs_to :lt
  belongs_to :gk
  has_many :laws
end
