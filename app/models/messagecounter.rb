class Messagecounter < ApplicationRecord
  establish_connection :fsm_mssql

  self.table_name = 'MessageCounter'
  self.primary_key = 'ID'

  scope :today, -> { where('filedate = ? ', Time.now) }
  scope :form_311_in_arch,  -> { where(filemask: 'f311inArch') }
  scope :form_440_in_arch,  -> { where(filemask: 'f440inArch') }
  scope :form_311_out_arch, -> { where(filemask: 'f311outArch') }
  scope :form_440_out_arch, -> { where(filemask: 'f440outArch') }
end
