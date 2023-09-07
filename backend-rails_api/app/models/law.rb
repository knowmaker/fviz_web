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

  validates :law_name, presence: true
  validates :first_element, :second_element, :third_element, :fourth_element, presence: true , numericality: { only_integer: true }, on: :create
  validates :id_user, presence: true, on: :create
  validates :id_type, numericality: { only_integer: true }, allow_nil: true
  validates :combination, presence: true, on: :create
  validate :unique_combination_user, on: :create

  private
  def unique_combination_user
    if Law.where(id_user: id_user, combination: combination).where.not(id_law: id_law).exists?
      errors.add(:combination, "Комбинация пользователя и закона должна быть уникальной")
    end
  end
end
