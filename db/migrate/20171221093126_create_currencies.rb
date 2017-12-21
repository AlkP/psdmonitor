class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :code,         limit: 3,   null: false
      t.string :abbreviation, limit: 3,   null: false
      t.string :name,         limit: 75,  null: false

      t.index ['code'], name: 'code', unique: true
    end
  end
end
