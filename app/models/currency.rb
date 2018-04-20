class Currency < ApplicationRecord
  establish_connection :fsm_mssql

  has_many :cb_rates, dependent: :destroy
  has_many :rates,    dependent: :destroy

  validates :code, :abbreviation, :name, presence: true
end
