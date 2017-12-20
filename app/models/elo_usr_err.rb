class EloUsrErr < ApplicationRecord
  establish_connection :elodb_mssql

  self.table_name = 'ELO_USR_ERR'
  self.primary_key = 'USERID'

  paginates_per 12

  belongs_to :elo_user, foreign_key: 'USERID', foreign_type: :numeric, primary_key: 'USRID'

  default_scope { order(TIME_: :desc) }

end