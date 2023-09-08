# frozen_string_literal: true

# Модель для хранения сведений об активных величинах представления
class Represent < ApplicationRecord
  self.table_name = 'represents'

  belongs_to :user, foreign_key: 'id_user'

  validates :title, presence: true, length: { maximum: 100 }
  validates :id_user, presence: true, numericality: { only_integer: true }
  validates :active_quantities, presence: true
  validate :active_quantities_array

  private
  def active_quantities_array
    errors.add(:active_quantities, "должны быть целыми числами") unless active_quantities.is_a?(Array) && active_quantities.all? { |q| q.is_a?(Integer) }
  end
end
