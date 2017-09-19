class HomeController < ApplicationController
  def index
    old_date = 11
    client = Elodb.new
    @title = "Ошибки за последние #{old_date} дней"
    @result = client.connect.execute("SELECT * FROM ELO_USR_ERR as err
                              LEFT OUTER JOIN ELO_USERS as usr
                              ON usr.USRID = err.USERID
                              Where err.TIME_ >= GETDATE()-#{old_date}
                              ORDER BY err.TIME_ DESC")
  end

  def history
    @title = "Выберите пользователя"
    client = Elodb.new
    @user = client.connect.execute("SELECT *
                            FROM ELO_USERS as usr
                            WHERE usr.USRID NOT IN (SELECT usr.USRID FROM ELO_USERS as usr
                            LEFT OUTER JOIN ELO_USER_JOB as job
                            ON usr.USRID = job.USERID
                            WHERE job.JOBID = -1 and job.DOSTUP = 1)
                            ORDER BY usr.USRNAME ASC")
  end

  def show_history
    old_date = 30
    client = Elodb.new
    @history = client.connect.execute("SELECT *
                                FROM ELO_USR_PROTOCOL
                                WHERE USERID = #{params['usrid']} AND TIME_ >= GETDATE()-#{old_date.to_i}
                                ORDER BY TIME_ DESC")
  end
end