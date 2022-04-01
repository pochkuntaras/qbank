# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :bank_account,  null: false, foreign_key: true

      t.string :counterparty_name, null: false
      t.string :counterparty_iban, null: false, limit: 34
      t.string :counterparty_bic,  null: false, limit: 11
      t.string :amount_currency,   null: false, limit: 3, default: 'EUR'
      t.string :description,       null: false

      t.integer :amount_cents,     null: false, default: 0

      t.timestamps
    end
  end
end
