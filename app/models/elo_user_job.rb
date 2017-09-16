class EloUserJob < ApplicationRecord

  self.table_name = "elo_user_job"
  self.primary_key = 'USERID'

  paginates_per 12

  belongs_to :elo_user, foreign_key: "USERID", primary_key: "USRID"

end