class Tinstrument < DiasoftRecord
  self.table_name = 'tInstrument'
  self.primary_key = 'InstrumentID'

  paginates_per 19

  # has_many    :tinstruments, foreign_key: 'ParentID',     foreign_type: :numeric, primary_key: 'InstrumentID'
  # belongs_to  :tinstrument, foreign_key: 'InstrumentID',  foreign_type: :numeric, primary_key: 'ParentID'
  # belongs_to  :tswift,      foreign_key: 'InstrumentID',  foreign_type: :numeric, primary_key: 'InstrumentID'

  scope :for_day, -> (day) { where("InDateTime >= '#{day.strftime("%Y-%m-%d")} 00:00'")
                             .where("InDateTime <= '#{day.strftime("%Y-%m-%d")} 23:59'") }

  scope :today, -> { for_day(Time.now) }

  scope :f440_out_diasoft, -> { where(type: 0)
                                .where('SampleID in (?)', [10030899075,10028949763,10034411824,10028949765,10034411825,
                                                           10028949764,10034411826,10029684925,10034411827])
                                .where(PathTo: '\\\\msk.genbank.local\\bank$\\diasoft\\exchange\\440p\\BRANCHES\\0000\\OUT\\TMP\\') }
end