# frozen_string_literal: true

# Модель для хранения сведений об активных величинах представления
class Represent < ApplicationRecord
  self.table_name = 'represents'

  belongs_to :user, foreign_key: 'id_user'
end
