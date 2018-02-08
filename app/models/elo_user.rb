class EloUser < ApplicationRecord
  establish_connection :elodb_mssql

  self.primary_key = 'USRID'

  paginates_per 19

  has_many :elo_usr_errs, foreign_key: 'USERID', foreign_type: :numeric, primary_key: 'USRID'
  # has_many :elo_usr_protocol, -> { where('TIME_ > ?', (Time.now - 2.week).to_date) }, foreign_key: 'USERID', foreign_type: :numeric, primary_key: 'USRID'
  has_many :elo_usr_protocol, foreign_key: 'USERID', foreign_type: :numeric, primary_key: 'USRID'
  has_many :elo_user_jobs, foreign_key: 'USERID', foreign_type: :numeric, primary_key: 'USRID'
  has_many :inactive_users, -> { where(JOBID: -1, DOSTUP: 1) }, foreign_key: 'USERID', primary_key: 'USRID', class_name: 'EloUserJob'

  default_scope { order(USRID: :desc) }

  def id
    self.USRID.to_i
  end

  def name
    self.USRNAME
  end

  def active?
    self.inactive_users.first.nil?
  end
end