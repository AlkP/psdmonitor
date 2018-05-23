class RegulationsController < ApplicationController
  def dashboards
    if user_signed_in? && current_user.dashboards?
      @f311_err         =  Messagecounter.form_311_err.take.try(:SERIALNUMBER)
      @f440_err         =  Messagecounter.form_440_err.take.try(:SERIALNUMBER)
      @srv9work         =  Messagecounter.srv9work.take.try(:SERIALNUMBER)
      @srv69post        =  Messagecounter.srv69post.take.try(:SERIALNUMBER)
      @srv57inc         =  Messagecounter.srv57inc.take.try(:SERIALNUMBER)

      @f311in           = Tfile.form_311_in.today.count
      @f311inArch       = Messagecounter.form_311_in_arch.today.take.try(:SERIALNUMBER)
      @f311out          = Tfile.form_311_out.today.count
      @f311outArch      = Messagecounter.form_311_out_arch.today.take.try(:SERIALNUMBER)
      @f311inDiasoft    = Tmbbuffer.joins(', tMBBufferIn mi')
                            .where("CAST(tMBBuffer.InDateTime AS DATE) = CAST('#{Time.now.strftime("%Y-%m-%d")}' AS DATE)")
                            .where('tMBBuffer.MBBufferID = mi.MBBufferID')
                            .where("mi.InAddress = 'T:\\FilGo\\receive'")
                            .count
      @f311outDiasoft   = Tresdate.joins(', tResource r')
                            .where("CAST(tResDate.DateLoadRecipient AS DATE) = CAST('#{Time.now.strftime("%Y-%m-%d")}' AS DATE)")
                            .where('tResDate.PropertyUsrID = 10000000400')
                            .where('tResDate.PropVal = 0')
                            .where('tResDate.resourceID = r.resourceID')
                            .where('r.InstitutionID = 2000')
                            .count
      @f311outKwit      = Tfile.joins(', [FSMonitor].[dbo].[TRELATIONS] t_arj, [FSMonitor].[dbo].[TFILES] arj, [FSMonitor].[dbo].[TRELATIONS] t_uv, [FSMonitor].[dbo].[TFILES] uv')
                              .where('CAST(tfiles.date AS DATE) = CAST(getdate() AS DATE)')
                              .where("tfiles.name like 'S[FB]C__3510123%xml'")
                              .where('t_arj.TFILE_ID = tfiles.ID')
                              .where('t_arj.TFILE_ID_PARENT = arj.ID')
                              .where('t_uv.TFILE_ID_PARENT = arj.ID')
                              .where("t_uv.type = '311_uvArh'")
                              .where('t_uv.TFILE_ID = uv.ID')
                              .where('uv.SUCCESS = 1')
                              .count
      @f440in           = Tfile.form_440_in.today.count
      @f440inArch       = Messagecounter.form_440_in_arch.today.take.try(:SERIALNUMBER)
      @f440inRequest    = Tfile.form_440_in_request.today.group('substring(name, 1, 3)').order('substring(name, 1, 3) asc').count
      @f440out          = Tfile.form_440_out.today.count
      @f440outArch      = Messagecounter.form_440_out_arch.today.take.try(:SERIALNUMBER)
      @f440inDiasoft    = Tswift.joins(', tinstrument as ip, tinstrument as ic')
                            .where("CAST(tswift.Date AS DATE) = CAST('#{Time.now.strftime("%Y-%m-%d")}' AS DATE)")
                            .where('tswift.InstrumentID = ip.InstrumentID')
                            .where('ip.DsModuleID = 21')
                            .where('ip.ParentID = ic.InstrumentID')
                            .where("(ic.Brief = '440-П' or ic.Brief = '440-П KWT')")
                            .where('tswift.BranchID = 2000')
                            .count
      @f440outDiasoft   = Tsmparchive
                              .f440_out_diasoft
                              .today
                              .count
      @f440outKwit      = Tfile.joins(', [FSMonitor].[dbo].[TRELATIONS] t_arj, [FSMonitor].[dbo].[TFILES] arj, [FSMonitor].[dbo].[TRELATIONS] t_uv, [FSMonitor].[dbo].[TFILES] uv')
                              .where('CAST(tfiles.date AS DATE) = CAST(getdate() AS DATE)')
                              .where("tfiles.name like 'PB1[_]____3510123%' or tfiles.name like 'PB2[_]____3510123%' or tfiles.name like '____[_]____3510123%'")
                              .where('t_arj.TFILE_ID = tfiles.ID')
                              .where('t_arj.TFILE_ID_PARENT = arj.ID')
                              .where('t_uv.TFILE_ID_PARENT = arj.ID')
                              .where("t_uv.type = 'izvtub'")
                              .where('t_uv.TFILE_ID = uv.ID')
                              .where('uv.SUCCESS = 1')
                              .count
    end
    respond_to do |format|
      format.html
      # format.html { flash[:alert] = 'Testik'; flash[:danger] = 'Testir' }
      format.js
    end
  end

  def charts
    filter = params['day'].present? ? params['day'].try(:to_i) : 7
    @dates = ((Time.now - filter.days).to_date..Time.now.to_date).to_a
    files = Tfile.per_days(filter)
    @f311_in_files  = @dates.collect { |x| files.form_311_in.count_by_date[x] }
    @f311_out_files = @dates.collect { |x| files.form_311_out.count_by_date[x] }
    @f440_in_files  = @dates.collect { |x| files.form_440_in.count_by_date[x] }
    @f440_out_files = @dates.collect { |x| files.form_440_out.count_by_date[x] }
    respond_to do |format|
      format.html
      format.js
    end
  end

  def f440
    @f440in           = Tfile.form_440_in.today
    @f440out          = Tfile.form_311_out.today.count
    @f440outDiasoft   = Tsmparchive
                          .f440_out_diasoft
                          .today
                          .count
  end

  def f311
    @in          = Tfile.form_311_in.today.count
    @out         = Tfile.form_311_out.today.count
    @inDiasoft   = Tfile.form_311_in.today.count
    @outDiasoft  = Tsmparchive
                            .f440_out_diasoft
                            .today
                            .count
    # @diasoftIn =
  end
end
