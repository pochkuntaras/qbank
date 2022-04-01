# frozen_string_literal: true

class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.string :organization_name, null: false
      t.string :iban,              null: false, limit: 34
      t.string :bic,               null: false, limit: 11

      t.integer :balance_cents,    null: false, default: 0

      t.timestamps
    end

    add_index :bank_accounts, :iban, unique: true
    add_index :bank_accounts, :bic,  unique: true
  end
end
