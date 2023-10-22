# frozen_string_literal: true

# Модель для хранения активных величинах представления
class Represent < ApplicationRecord
  self.table_name = 'represents'

  belongs_to :user, foreign_key: 'id_user'
  has_many :users, foreign_key: 'active_repr'

  before_destroy :check_user_represents_count

  validates :title, presence: true, length: { maximum: 100 }
  validates :id_user, presence: true, numericality: { only_integer: true }
  validates :active_quantities, presence: true
  validate :active_quantities_array

  private

  def active_quantities_array
    return unless active_quantities.present?

    active_quantities.each do |quantity|
      number = quantity.to_i

      if number.to_s != quantity.to_s || number.zero?
        errors.add(:active_quantities, :not_a_number)
        break
      end
    end
  end

  def check_user_represents_count
    if user.represents.count == 1
      errors.add(:base, I18n.t('errors.messages.delete_represent'))
      throw(:abort)
    end
  end
end
