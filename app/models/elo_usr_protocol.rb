class EloUsrProtocol < ApplicationRecord

  self.table_name = "elo_usr_protocol"
  self.primary_key = 'USERID'

  paginates_per 12

  belongs_to :elo_user, foreign_key: "USERID", primary_key: "USRID"

  default_scope { order(TIME_: :desc) }

end