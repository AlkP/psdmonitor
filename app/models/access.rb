class Access < ApplicationRecord
  establish_connection :fsm_mssql

  belongs_to  :user,  optional: true

  enum type: { guest: 0, admin: 1, f211: 10, f311: 15, f364: 20, f406: 25, f440: 30, f550: 35 }
end
