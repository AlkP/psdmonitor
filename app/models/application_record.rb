class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  ActiveRecord::Base.table_name_prefix = 'dbo.'
end
