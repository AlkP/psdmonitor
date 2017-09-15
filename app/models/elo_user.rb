class EloUser < ApplicationRecord

  self.primary_key = 'USRID'

  default_scope { order(USRID: :desc) }

  def id
    self.USRID.to_i
  end

  def name
    self.USRNAME
  end

  def informations
    UserInformation.where(UNICODE: '$user$' + self.id.to_s)
  end

end