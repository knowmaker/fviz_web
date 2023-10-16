# frozen_string_literal: true

# Модель для хранения сведений о пользователе
class User < ApplicationRecord
  include UserHelper
  self.table_name = 'users'

  has_many :laws, foreign_key: 'id_user'
  has_many :represents, foreign_key: 'id_user'
  belongs_to :represent, foreign_key: 'active_repr', optional: true

  before_save :hash_user_password, if: :password_changed?
  before_save :generate_confirmation_token, if: :new_record?

  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }
  validates :last_name, :first_name, :patronymic, length: { maximum: 100 }
  validates :role, inclusion: { in: [true, false] }
  validates :confirmed, inclusion: { in: [true, false] }
  validates :confirmation_token, presence: true, allow_nil: true
  validates :active_repr, presence: true, allow_nil: true

  def as_json(options = {})
    super(except: [:password, :confirmation_token])
  end

  private

  def hash_user_password
    self.password = hash_password(password)
  end

  def generate_confirmation_token
    self.confirmation_token ||= SecureRandom.urlsafe_base64.to_s
  end
end
