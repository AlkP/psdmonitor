class Messagecounter < ApplicationRecord
  establish_connection :fsm_mssql

  self.table_name = 'MessageCounter'
  self.primary_key = 'ID'

  scope :today, -> { where('filedate = ? ', Time.now) }
  scope :form_311_in_arch,  -> { where(filemask: 'f311inArch') }
  scope :form_440_in_arch,  -> { where(filemask: 'f440inArch') }
  scope :form_311_out_arch, -> { where(filemask: 'f311outArch') }
  scope :form_440_out_arch, -> { where(filemask: 'f440outArch') }
  scope :form_311_err,      -> { where(filemask: 'f311err').where(filedate: '20020202') }
  scope :form_440_err,      -> { where(filemask: 'f440err').where(filedate: '20020202') }
  scope :srv9work,          -> { where(filemask: 'srv9work').where(filedate: '20020202') }
  scope :srv69post,         -> { where(filemask: 'srv69post').where(filedate: '20020202') }
  scope :srv57inc,          -> { where(filemask: 'srv57inc').where(filedate: '20020202') }
end
