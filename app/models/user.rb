class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable

  def authenticate!(username, password)
    user = User.find_for_database_authentication(name: username)

    user if user.valid_for_authentication? { user.valid_password?(password) } && user.active_for_authentication?
  end
end