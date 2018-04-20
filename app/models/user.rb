class User < ApplicationRecord
  establish_connection :fsm_mssql

  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :omniauthable, :validatable
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :lockable, authentication_keys: [:login]

  has_many  :accesses,  dependent: :delete_all
end
