class DiasoftRecord < ApplicationRecord
  establish_connection :diasoft_mssql

  default_scope { lock('WITH (NOLOCK)') }
end
