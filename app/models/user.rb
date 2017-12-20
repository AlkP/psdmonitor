class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :omniauthable, :validatable
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :lockable, authentication_keys: [:login]

  enum role: { admin: 0, guest: -1, manager: 1, f211: 2, f406: 3, f440: 4, f550: 5 }
end
