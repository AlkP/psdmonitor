class CreateCbRates < ActiveRecord::Migration[5.1]
  def change
    create_table :cb_rates do |t|
      t.integer :currency_id, null: false,  limit: 5
      t.date    :date,        null: false
      t.integer :scale,       null: false,  limit: 4,       default: 1
      t.decimal :course,      null: false,  precision: 16,  scale: 5

      t.timestamps

      t.index ['currency_id'],          name: 'currency'
      t.index ['date'],                 name: 'date'
      t.index ['currency_id', 'date'],  name: 'date_currency_id_unique',  unique: true
    end
  end
end
