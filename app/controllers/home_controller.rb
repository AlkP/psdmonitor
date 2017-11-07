class HomeController < ApplicationController
  before_action :set_client

  @@path_error_440 = "//msk.genbank.local/bank$/diasoft/exchange/440p/BRANCHES/003/OUT/Err/"
  # @@path_error_440 = "d:/a/"

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
    userid = "#{params['usrid'].to_i}"
    @history = @client.sql.execute("SELECT *
                                FROM ELO_USR_PROTOCOL
                                WHERE USERID = #{userid} AND TIME_ >= GETDATE()-#{old_date.to_i}
                                ORDER BY TIME_ DESC")
  end

  def status_report
    @date = params[:date].nil? ? DateTime.now.to_date.to_s : params[:date]
    if ( @date.length > 10 )
      redirect_to root_path
    else
      @f440_out = @client.sql.execute("SELECT f.id f_id
                                            , f.name name
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
      @f311_out = client7.sql.execute("SELECT f.id f_id
                                            , f.name name
                                            , CONVERT(char(10), f.time, 108) time
                                            , r_file.name kvit
                                            , CONVERT(char(10), r_file.time, 108) time_kvit
                                            , r_file.success kvit_success
                                            , rez.value msg
                                      FROM fsmonitor.dbo.tfiles f
                                        left join fsmonitor.dbo.trelations r on r.tfile_id_parent = f.id and r.type = '311_uvArh'
                                        left join fsmonitor.dbo.tfiles r_file on r_file.id = r.tfile_id
                                        left join FSMonitor.dbo.TXML_DATA rez on rez.tfile_id = r_file.id and rez.type = 'Element' and rez.name = N'REZ_ARH'
                                      where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                              and f.name like '[AB]N10123__________.arj'
                                      order by f.id asc")
      client8 = Elodb.new
      @f311_in = client8.sql.execute("SELECT f.name name
                                            , CONVERT(char(10), f.time, 108) time
                                      FROM fsmonitor.dbo.tfiles f
                                      where CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)
                                              and (f.name like 'ON10123__________.arj' or f.name like 'NN10123__________.arj' or f.name like 'S10123________.arj')
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
                                    where ( name like 'ON10123__________.arj' or name like 'NN10123__________.arj' or name like 'S10123________.arj' )
                                          and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                    group by date), 0) as count;

                                    SELECT ISNULL((SELECT count(*) count
                                    FROM FSMonitor.dbo.tfiles
                                    where name like '[AB]N10123__________.arj'
                                          and CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                    group by date), 0) as count;

                                    SELECT ISNULL((SELECT count(*) count
                                    FROM elodb.dbo.elo_arh_post f
                                    where (f.filetype = N'ИЭС1' or f.filetype = N'ИЭС2') and f.filename like '2z____10.123%' and f.posttype = '2z' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
                                    group by f.posttype), 0) as count;

                                    SELECT 0 as count;

                                    SELECT ISNULL((SELECT count(*) count
                                    FROM elodb.dbo.elo_arh_post f
                                    where f.filetype = N'ОЭС' and f.filename like '2z___123.010%' and f.posttype = '2z' and CAST(f.dt AS DATE) = CAST('#{@date}' AS DATE)
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
      counts_load_Diasoft = client10.sql.execute("SELECT ISNULL((select count(*) count
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
                                    group by ic.Brief), 0) as count;

                                    SELECT ISNULL((select count(*) count
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
                                    group by ic.Brief), 0) as count;

                                    SELECT ISNULL((select count(*) count
                                    from tResDate     rr   with (nolock)
                                           ,tResource    r    with (nolock)
                                    where rr.PropertyUsrID = 10000000400
                                       and rr.PropVal = 0
                                       and rr.resourceID = r.resourceID
                                       and CAST(rr.DateLoadRecipient as DATE) = CAST('#{@date}' AS DATE)
                                       and r.InstitutionID = 2000
                                    group by CAST(rr.DateLoadRecipient as DATE)), 0) as count;

                                    ")
      @f440_count_diasoft_request,
      @f440_count_diasoft_kwtfcb,
      @f311_count_diasoft =
          counts_load_Diasoft.collect { |c| c["count"] }

      client11 = Elodb.new
      counts_311 = client11.sql.execute("SELECT SUBSTRING ( name ,1 ,3 ) type, count(*) count
                                    FROM [FSMonitor].[dbo].[TFILES]
                                    where CAST(date AS DATE) = CAST('#{@date}' AS DATE)
                                    and (name like 'SBC%.xml' or name like 'SFC%.xml')
                                    group by SUBSTRING ( name ,1 ,3 )")

      counts_311.each do |f|
        @f311_count_sbc = f['count'] if f['type'] == 'SBC'
        @f311_count_sfc = f['count'] if f['type'] == 'SFC'
      end

      @f440_error = []
      Dir[@@path_error_440 + "*"].each { |f| @f440_error << /^[^.]*/.match(/[^\/]*$/.match(f).to_s) }

      # cmd = "call c:\\utils\\files_count.cmd c:\\work\\diasoft\\in\\*"
      # @f440_count_diasoft_in = (%x( #{cmd} ))

    end
  end

  def print
    search = params[:search].to_s
    @date = params[:date].nil? ? DateTime.now.to_date.to_s : params[:date]
    if search == ''
      if ( @date.length > 10 )
        redirect_to root_path
      else
        @list = @client.sql.execute("
                                      select f.id id, f.name name, CONVERT(char(10), f.time, 108) time
                                              , sbe.id id_sbe, sbe.name sbe, sbe.date sbe_date
                                              , sbf.id id_sbf, sbf.name sbf, sbf.date sbf_date
                                              , sbp.id id_sbp, sbp.name sbp, sbp.date sbp_date
                                              , sbr.id id_sbr, sbr.name sbr, sbr.date sbr_date
                                      from fsmonitor.dbo.tfiles f

                                      left join fsmonitor.dbo.trelations rel_sbe
                                        on f.ID = rel_sbe.TFILE_ID_PARENT
                                        and rel_sbe.type = 'sbe'
                                      left join fsmonitor.dbo.tfiles sbe
                                        on sbe.id = rel_sbe.TFILE_ID

                                      left join fsmonitor.dbo.trelations rel_sbf
                                        on f.ID = rel_sbf.TFILE_ID_PARENT
                                        and rel_sbf.type = 'sbf'
                                      left join fsmonitor.dbo.tfiles sbf
                                        on sbf.id = rel_sbf.TFILE_ID

                                      left join fsmonitor.dbo.trelations rel_sbp
                                        on f.ID = rel_sbp.TFILE_ID_PARENT
                                        and rel_sbp.type = 'sbp'
                                      left join fsmonitor.dbo.tfiles sbp
                                        on sbp.id = rel_sbp.TFILE_ID

                                      left join fsmonitor.dbo.trelations rel_sbr
                                        on f.ID = rel_sbr.TFILE_ID_PARENT
                                        and rel_sbr.type = 'sbr'
                                      left join fsmonitor.dbo.tfiles sbr
                                        on sbr.id = rel_sbr.TFILE_ID

                                      where f.name like 'SBC__3510123[_]%.xml'
                                        and CAST(f.date AS DATE) = CAST('#{@date}' AS DATE)

                                      order by f.name
")
      end
    else
      if ((search.length > 3) && (search.length < 8))
        @list = @client.sql.execute("SELECT TOP 99 f.id id, f.name name, CAST(f.date AS DATE) time
                                      FROM fsmonitor.dbo.tfiles f
                                      where f.name like 'SB%#{search}%.xml'
                                      order by f.id DESC")
      else
        redirect_to root_path
      end
    end
  end

  def show_file
    @pp = "#{params[:id].to_i}"
    file = @client.sql.execute("SELECT f.id id, f.name name, date as date
                                  FROM fsmonitor.dbo.tfiles f
                                  where f.id = #{@pp}")
    el = file.first
    date = "#{el['date']}".gsub('-','.')
    @content = File.open("c:\\files.arh\\#{date[0..3]}\\#{date[0..6]}\\#{date[0..9]}\\#{el['name']}", 'r:windows-1251').read
    # @content = File.open("c:\\123\\SFC013510123_910220171023_249000001700213747_700.xml", 'r:windows-1251').read
  end

  def show_error
    xml = "#{params[:file_name]}.xml"
    if xml.correct_filename_for_form_440?
      @content = File.open(@@path_error_440 + xml, 'r:windows-1251').read
    end
    # puts "BVD1_ZSV13510123_027720171031_004922_20171101_0000_000001_000001.xml".correct_filename_for_form_440?
  end

  private

  def set_client
    @client = Elodb.new
  end
end