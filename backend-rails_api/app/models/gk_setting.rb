# frozen_string_literal: true

# Модель для хранения настроек цвета слоев для пользователей
class GkSetting < ApplicationRecord
  self.table_name = 'gk_settings'

  belongs_to :gk, foreign_key: 'id_gk'
  belongs_to :user, foreign_key: 'id_user'
end
