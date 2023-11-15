# frozen_string_literal: true

# Модель для хранения пользователей
class User < ApplicationRecord
  self.table_name = 'users'

  has_many :laws, foreign_key: 'id_user'
  has_many :represents, foreign_key: 'id_user'
  belongs_to :represent, foreign_key: 'active_repr', optional: true

  before_save :hash_user_password, if: :password_changed?

  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 },  :format => {:with => /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}\z/ }
  validates :last_name, :first_name, :patronymic, length: { maximum: 100 }
  validates :role, inclusion: { in: [true, false] }
  validates :confirmed, inclusion: { in: [true, false] }
  validates :confirmation_token, presence: true, allow_nil: true
  validates :active_repr, presence: true, allow_nil: true

  def as_json(_options = {})
    super(except: %i[password confirmation_token])
  end

  private

  def hash_user_password
    self.password = Argon2::Password.create(password)
  end
end
