# frozen_string_literal: true

# Модель для хранения сведений об активных величинах представления
class Represent < ApplicationRecord
  self.table_name = 'represents'

  belongs_to :user, foreign_key: 'id_user'
  has_many :users, foreign_key: 'active_repr'

  validates :title, presence: true, length: { maximum: 100 }
  validates :id_user, presence: true, numericality: { only_integer: true }
  validates :active_quantities, presence: true
  validate :active_quantities_array

  private

  def active_quantities_array
    return unless active_quantities.present?

    active_quantities.each do |quantity|
      number = quantity.to_i

      if number.to_s != quantity.to_s || number == 0
        errors.add(:active_quantities, 'должны быть непустыми целыми числами')
        break
      end
    end
  end

end
