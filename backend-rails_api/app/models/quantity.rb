# frozen_string_literal: true

# Модель для хранения сведений о всех физических величинах системы
class Quantity < ApplicationRecord
  self.table_name = 'quantity'

  belongs_to :lt, foreign_key: 'id_lt'
  belongs_to :gk, foreign_key: 'id_gk'

  has_many :laws_as_first_element, class_name: 'Law', foreign_key: 'first_element'
  has_many :laws_as_second_element, class_name: 'Law', foreign_key: 'second_element'
  has_many :laws_as_third_element, class_name: 'Law', foreign_key: 'third_element'
  has_many :laws_as_fourth_element, class_name: 'Law', foreign_key: 'fourth_element'

  validates :value_name, length: { maximum: 200 }
  validates :symbol, length: { maximum: 100 }
  validates :m_indicate_auto, :l_indicate_auto, :t_indicate_auto, :i_indicate_auto, presence: true,
                                                                                    numericality: { only_integer: true }
  validates :unit, length: { maximum: 200 }
  validates :id_lt, :id_gk, presence: true, numericality: { only_integer: true }
  validates :mlti_sign, length: { maximum: 100 }
  validates :id_gk, uniqueness: { scope: :id_lt, message: 'должен быть уникальным в сочетании с LT' }
end
