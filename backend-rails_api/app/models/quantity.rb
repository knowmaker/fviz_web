# frozen_string_literal: true

# Модель для хранения физических величин
class Quantity < ApplicationRecord
  self.table_name = 'quantity'

  belongs_to :lt, foreign_key: 'id_lt'
  belongs_to :gk, foreign_key: 'id_gk'

  has_many :laws_as_first_element, class_name: 'Law', foreign_key: 'first_element'
  has_many :laws_as_second_element, class_name: 'Law', foreign_key: 'second_element'
  has_many :laws_as_third_element, class_name: 'Law', foreign_key: 'third_element'
  has_many :laws_as_fourth_element, class_name: 'Law', foreign_key: 'fourth_element'
  has_many :quantity_translations, foreign_key: 'id_value'
  translates :value_name, :unit, foreign_key: 'id_value', table_name: 'quantity_translations',
                                 fallbacks_for_empty_translations: true

  validates :value_name, length: { maximum: 200 }
  validates :symbol, length: { maximum: 100 }
  validates :m_indicate_auto, :l_indicate_auto, :t_indicate_auto, :i_indicate_auto, presence: true,
                                                                                    numericality: { only_integer: true }
  validates :unit, length: { maximum: 100 }
  validates :id_lt, :id_gk, presence: true, numericality: { only_integer: true }
  validates :id_gk, uniqueness: { scope: :id_lt, message: I18n.t('errors.messages.gk_lt_combination_taken') }
end
