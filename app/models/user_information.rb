class UserInformation < ApplicationRecord

  self.table_name = "ldv_add_info"

  def elo_user_id
    if self.UNICODE[0..5] == '$user$'
      self.UNICODE[6..10].to_i
    else
      0
    end
  end

end