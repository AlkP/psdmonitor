class AddForeignKeyCurrencyToRates < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :rates,     :currencies,  column: :currency_id, primary_key: :id
    add_foreign_key :cb_rates,  :currencies,  column: :currency_id, primary_key: :id
  end
end
