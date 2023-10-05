# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user/confirmation_email
  def confirmation_email
    UserMailer.confirmation_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/user/new_password_email
  def new_password_email
    UserMailer.new_password_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/user/reset_password_email
  def reset_password_email
    UserMailer.reset_password_email
  end
end
