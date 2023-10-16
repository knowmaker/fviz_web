# frozen_string_literal: true

# Модель для хранения законов, созданных пользователями
class Law < ApplicationRecord
  self.table_name = 'laws'

  belongs_to :law_type, foreign_key: 'id_type', optional: true
  belongs_to :user, foreign_key: 'id_user'

  before_validation :set_combination, on: :create

  belongs_to :first_element_quantity, class_name: 'Quantity', foreign_key: 'first_element'
  belongs_to :second_element_quantity, class_name: 'Quantity', foreign_key: 'second_element'
  belongs_to :third_element_quantity, class_name: 'Quantity', foreign_key: 'third_element'
  belongs_to :fourth_element_quantity, class_name: 'Quantity', foreign_key: 'fourth_element'

  validates :law_name, presence: true
  validates :first_element, :second_element, :third_element, :fourth_element, presence: true,
                                                                              numericality: { only_integer: true }
  validates :id_user, presence: true, numericality: { only_integer: true }
  validates :id_type, numericality: { only_integer: true }, allow_nil: true
  validates :combination, presence: true
  validates :combination,
            uniqueness: { scope: :id_user, message: I18n.t('errors.messages.combination_user_combination_taken') }

  private

  def set_combination
    elements = [first_element, second_element, third_element, fourth_element]
    non_nil_elements = elements.compact
    self.combination = (non_nil_elements.sort if non_nil_elements.length == 4)
  end
end
