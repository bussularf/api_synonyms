class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable

  def custom_authenticate(username, password)
    user = User.find_for_database_authentication(username: username)

    if user&.valid_for_authentication? && user&.valid_password?(password) && user&.active_for_authentication?
      return user
    else
      return nil
    end
  end
end
