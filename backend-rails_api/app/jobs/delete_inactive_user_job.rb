class DeleteInactiveUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    return unless user

    user.destroy
  end
end
