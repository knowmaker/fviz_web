# frozen_string_literal: true

# Модуль дополнительных функций для работы с методами класса пользователей
module UserHelper

  def generate_random_password
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(12) { charset.sample }.join
  end
end
