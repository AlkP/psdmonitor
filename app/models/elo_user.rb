class EloUser < ApplicationRecord

  self.primary_key = 'USRID'

  paginates_per 19

  default_scope { order(USRID: :desc) }

  has_many :elo_usr_errs, -> { where("TIME_ > '#{(Time.now - 2.week).to_date}'") }, foreign_key: "USERID", primary_key: "USRID"
  has_many :elo_usr_protocol, -> { where("TIME_ > '#{(Time.now - 2.week).to_date}'") }, foreign_key: "USERID", primary_key: "USRID"
  has_many :elo_user_jobs, foreign_key: "USERID", primary_key: "USRID"
  has_many :check_user_active, -> { where(JOBID: -1, DOSTUP: 1) }, foreign_key: "USERID", primary_key: "USRID", class_name: EloUserJob

  def id
    self.USRID.to_i
  end

  def name
    self.USRNAME
  end

  def active?
    self.check_user_active.first.nil?
  end

  def informations
    UserInformation.where(UNICODE: '$user$' + self.id.to_s)
  end

end