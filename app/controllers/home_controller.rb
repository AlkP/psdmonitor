class HomeController < ApplicationController
  before_action :set_client

  def index
    old_date = 11
    @title = "Ошибки за последние #{old_date} дней"
    @result = @client.sql.execute("SELECT * FROM ELO_USR_ERR as err
                              LEFT OUTER JOIN ELO_USERS as usr
                              ON usr.USRID = err.USERID
                              Where err.TIME_ >= GETDATE()-#{old_date}
                              ORDER BY err.TIME_ DESC")
  end

  def history
    @title = "Выберите пользователя"
    @user = @client.sql.execute("SELECT *
                            FROM ELO_USERS as usr
                            WHERE usr.USRID NOT IN (SELECT usr.USRID FROM ELO_USERS as usr
                            LEFT OUTER JOIN ELO_USER_JOB as job
                            ON usr.USRID = job.USERID
                            WHERE job.JOBID = -1 and job.DOSTUP = 1)
                            ORDER BY usr.USRNAME ASC")
  end

  def show_history
    old_date = 30
    @history = @client.sql.execute("SELECT *
                                FROM ELO_USR_PROTOCOL
                                WHERE USERID = #{params['usrid']} AND TIME_ >= GETDATE()-#{old_date.to_i}
                                ORDER BY TIME_ DESC")
  end

  def status_report
    @date = params[:date].nil? ? DateTime.now.to_date : params[:date]
    @f400_out = @client.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                          , r_file.name izvtub
                                          , CONVERT(char(10), r_file.time, 108) time_izvtub
                                          , r_file.success izvtub_success
                                    FROM fsmonitor.dbo.tfiles f
                                      left join fsmonitor.dbo.trelations r on r.tfile_id_parent = f.id and r.type = 'izvtub'
                                      left join fsmonitor.dbo.tfiles r_file on r_file.id = r.tfile_id
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like 'AF_[_]3510123_MIFNS00%.arj'
                                    order by f.id asc")
    client2 = Elodb.new
    @f400_in = client2.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                    FROM fsmonitor.dbo.tfiles f
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like 'AF_[_]MIFNS00_3510123%.arj'
                                    order by f.id asc")
    client3 = Elodb.new
    counts = client3.sql.execute("SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where (name like '____3510123[_]%.vrb' or name like 'KWTFCB%.xml')
                                        and CAST(date AS date) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where (name like '____[_]____3510123[_]%.vrb' or name like 'PB_[_]%.xml')
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where name like 'AF_[_]MIFNS00[_]3510123[_]%.arj'
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where name like 'AF_[_]3510123[_]MIFNS00[_]%.arj'
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where f.filetype = 'ИЭС2' and f.posttype = 'mz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where f.filetype = 'ИЭС1' and f.posttype = 'mz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where f.filetype = 'ОЭС' and f.posttype = 'mz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;")
    @f400_count_in,
    @f400_count_out,
    @f400_count_arj_in,
    @f400_count_arj_out,
    @f400_count_ptkpsd_in,
    @f400_count_ptkpsd_in_error,
    @f400_count_ptkpsd_out =
        counts.collect { |c| c["count"] }
    cmd = "call c:\\utils\\files_count_in_archive.cmd #{@date}"
    @f400_count_arj_system_in, @f400_count_arj_system_out = (%x( #{cmd} )).split(',')
    cmd = "call c:\\utils\\files_count.cmd c:\\work\\diasoft\\in\\*"
    @f400_count_diasoft_in = (%x( #{cmd} ))
  end

  private

  def set_client
    @client = Elodb.new
  end
end