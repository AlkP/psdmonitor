class ApplicationRecord < ActiveRecord::Base
  establish_connection :fsm_mssql

  self.abstract_class = true
  ActiveRecord::Base.table_name_prefix = 'dbo.'

  scope :sort_by_session, -> (session) { order(session['sort'].to_sym => session['index'].to_sym) unless (session.nil? or session['sort'].nil? or session['index'].nil?) }
end
