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
    @f440_out = @client.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                          , r_file.name kvit
                                          , CONVERT(char(10), r_file.time, 108) time_kvit
                                          , r_file.success kvit_success
                                    FROM fsmonitor.dbo.tfiles f
                                      left join fsmonitor.dbo.trelations r on r.tfile_id_parent = f.id and r.type = 'izvtub'
                                      left join fsmonitor.dbo.tfiles r_file on r_file.id = r.tfile_id
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like 'AF_[_]3510123_MIFNS00%.arj'
                                    order by f.id asc")
    client2 = Elodb.new
    @f440_in = client2.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                    FROM fsmonitor.dbo.tfiles f
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like 'AF_[_]MIFNS00_3510123%.arj'
                                    order by f.id asc")
    client3 = Elodb.new
    counts_440 = client3.sql.execute("SELECT ISNULL((SELECT count(*) count
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
                                  where f.filetype = N'ИЭС1' and f.posttype = 'mz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where f.filetype = N'ОЭС' and f.posttype = 'mz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;")
    client4 = Elodb.new
    @f550_out = client4.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                          , r_file.name kvit
                                          , CONVERT(char(10), r_file.time, 108) time_kvit
                                          , r_file.success kvit_success
                                    FROM fsmonitor.dbo.tfiles f
                                      left join fsmonitor.dbo.trelations r on r.tfile_id_parent = f.id and r.type = '550_uvArh'
                                      left join fsmonitor.dbo.tfiles r_file on r_file.id = r.tfile_id
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like 'ARH550P[_]2490[_]0000[_]%.arj'
                                    order by f.id asc")
    client5 = Elodb.new
    @f550_in = client5.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                    FROM fsmonitor.dbo.tfiles f
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like 'cb[_]550p[_]%.arj'
                                    order by f.id asc")
    client6 = Elodb.new
    counts_550 = client6.sql.execute("SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where (name like 'CB[_]ES550P[_]%.XML')
                                        and CAST(date AS date) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where (name like 'UV[_]2490[_]0000[_]CB[_]ES550P[_]%.XML')
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where name like 'cb[_]550p[_]%.arj'
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where name like 'ARH550P[_]2490[_]0000[_]%.arj'
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where (f.filetype = N'ИЭС1' or f.filetype = N'ИЭС2') and f.filename like 'wz____10.123%' and f.posttype = 'wz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.posttype), 0) as count;

                                  SELECT 0 as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where f.filetype = N'ОЭС' and f.filename like 'wz___123.010%' and f.posttype = 'wz' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;")
    client7 = Elodb.new
    @f311_out = client7.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                          , r_file.name kvit
                                          , CONVERT(char(10), r_file.time, 108) time_kvit
                                          , r_file.success kvit_success
                                    FROM fsmonitor.dbo.tfiles f
                                      left join fsmonitor.dbo.trelations r on r.tfile_id_parent = f.id and r.type = '311_uvArh'
                                      left join fsmonitor.dbo.tfiles r_file on r_file.id = r.tfile_id
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and f.name like '[AB]N10123__________.arj'
                                    order by f.id asc")
    client8 = Elodb.new
    @f311_in = client8.sql.execute("SELECT f.name name
                                          , CONVERT(char(10), f.time, 108) time
                                    FROM fsmonitor.dbo.tfiles f
                                    where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                            and (f.name like 'ON10123__________.arj' or f.name like 'S10123________.arj')
                                    order by f.id asc")
    client9 = Elodb.new
    counts_311 = client9.sql.execute("SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where (name like 'S[BKF][EFPR]__3510123[_]____________[_]24900000__________[_]___.XML')
                                        and CAST(date AS date) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where (name like 'S[BKF]C__3510123[_]____________[_]24900000__________[_]___.XML')
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where ( name like 'ON10123__________.arj' or name like 'S10123________.arj' )
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM FSMonitor.dbo.tfiles
                                  where name like '[AB]N10123__________.arj'
                                        and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                  group by date), 0) as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where (f.filetype = N'ИЭС1' or f.filetype = N'ИЭС2') and f.filename like '0z____10.123%' and f.posttype = '0z' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.posttype), 0) as count;

                                  SELECT 0 as count;

                                  SELECT ISNULL((SELECT count(*) count
                                  FROM elodb.dbo.elo_arh_post f
                                  where f.filetype = N'ОЭС' and f.filename like '0z___123.010%' and f.posttype = '0z' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                  group by f.filetype), 0) as count;")
    @f311_count_in,
    @f311_count_out,
    @f311_count_arj_in,
    @f311_count_arj_out,
    @f311_count_ptkpsd_in,
    @f311_count_ptkpsd_in_error,
    @f311_count_ptkpsd_out =
        counts_311.collect { |c| c["count"] }

    @f440_count_in,
    @f440_count_out,
    @f440_count_arj_in,
    @f440_count_arj_out,
    @f440_count_ptkpsd_in,
    @f440_count_ptkpsd_in_error,
    @f440_count_ptkpsd_out =
        counts_440.collect { |c| c["count"] }

    @f550_count_in,
    @f550_count_out,
    @f550_count_arj_in,
    @f550_count_arj_out,
    @f550_count_ptkpsd_in,
    @f550_count_ptkpsd_in_error,
    @f550_count_ptkpsd_out =
        counts_550.collect { |c| c["count"] }

    cmd = "call c:\\utils\\files_count_in_archive.cmd #{@date}"
    @f311_count_arj_system_in,
    @f311_count_arj_system_out,
    @f440_count_arj_system_in,
    @f440_count_arj_system_out,
    @f550_count_arj_system_in,
    @f550_count_arj_system_out =
        (%x( #{cmd} )).split(',')

    if Time.now.strftime("%Y-%m-%d") == "#{@date}"
      cmd = "call c:\\utils\\files_count.cmd"
      @f440_count_diasoft_in,
      @f440_count_tmp,
      @f440_count_err =
          (%x( #{cmd} )).split(',')
    end

    client10 = Diaswork.new
    counts_440_load_in_Diasoft = client10.sql.execute("select count(*) count
                                  from tSwift         sw  with (nolock)
                                      ,tInstrument    ip  with (nolock index = XAK1tInstrument)
                                      ,tInstrument    ic  with (nolock index = XAK1tInstrument)
                                  where 1=1
                                  and CAST(sw.Date AS DATE) = CAST('#{@date}' AS DATE)
                                    and sw.InstrumentID = ip.InstrumentID
                                    and ip.DsModuleID = 21
                                    and ip.ParentID = ic.InstrumentID
                                    and ic.Brief = '440-П'
                                    and sw.BranchID = 2000
                                  group by ic.Brief;

                                  select count(*) count
                                    from tSwift         sw  with (nolock)
                                      ,tInstrument    ip  with (nolock index = XAK1tInstrument)
                                      ,tInstrument    ic  with (nolock index = XAK1tInstrument)
                                  where 1=1
                                  and CAST(sw.Date AS DATE) = CAST('#{@date}' AS DATE)
                                    and sw.InstrumentID = ip.InstrumentID
                                    and ip.DsModuleID = 21
                                    and ip.ParentID = ic.InstrumentID
                                    and ic.Brief = '440-П квит'
                                    and sw.BranchID = 2000
                                  group by ic.Brief;

                                  ")
    @f440_count_diasoft_request,
    @f440_count_diasoft_kwtfcb =
        counts_440_load_in_Diasoft.collect { |c| c["count"] }

    # cmd = "call c:\\utils\\files_count.cmd c:\\work\\diasoft\\in\\*"
    # @f440_count_diasoft_in = (%x( #{cmd} ))
  end

  private

  def set_client
    @client = Elodb.new
  end
end