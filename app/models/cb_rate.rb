class CbRate < ApplicationRecord
  establish_connection :fsm_mssql

  belongs_to :currency, foreign_key: :currency_id

  validates :currency_id, :date, :scale, :course, presence: true
end
