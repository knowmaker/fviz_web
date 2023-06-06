class GkSetting < ApplicationRecord
  self.table_name = "gk_settings"
  alias_attribute :gk_id, :id_gk
  alias_attribute :user_id, :id_user
  belongs_to :user
  belongs_to :gk
end
