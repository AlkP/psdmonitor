class Elodb < ApplicationRecord
  def initialize
    @connect = TinyTds::Client.new username: 'USERNAME', password: 'PASSWORD',  host: 'IP_ADDRESS', port: '1433', database: 'DATABASE_NAME'
  end

  def connect
    @connect
  end
end