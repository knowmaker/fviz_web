# frozen_string_literal: true

# Модель для хранения законов, созданных пользователями
class Law < ApplicationRecord
  self.table_name = 'laws'

  belongs_to :law_type, foreign_key: 'id_type'
  belongs_to :user, foreign_key: 'id_user'

  belongs_to :first_element_quantity, class_name: 'Quantity', foreign_key: 'first_element'
  belongs_to :second_element_quantity, class_name: 'Quantity', foreign_key: 'second_element'
  belongs_to :third_element_quantity, class_name: 'Quantity', foreign_key: 'third_element'
  belongs_to :fourth_element_quantity, class_name: 'Quantity', foreign_key: 'fourth_element'
end
