class User < ApplicationRecord
  establish_connection :fsm_mssql

  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :omniauthable, :validatable, :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :lockable, authentication_keys: [:login]

  has_many  :accesses,  dependent: :delete_all

  def admin?
    self.accesses.find_by(role: 1).present?
  end

  def dashboards?
    self.accesses.find_by(role: 5).present?
  end

  def autorefresh?
    self.accesses.find_by(role: 6).present?
  end

  def charts?
    self.accesses.find_by(role: 8).present?
  end

  def f440?
    self.accesses.find_by(role: 30).present?
  end

  def f311?
    self.accesses.find_by(role: 15).present?
  end
end
