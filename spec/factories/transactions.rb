# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id                :bigint           not null, primary key
#  amount_cents      :integer          default(0), not null
#  amount_currency   :string(3)        default("EUR"), not null
#  counterparty_bic  :string(11)       not null
#  counterparty_iban :string(34)       not null
#  counterparty_name :string           not null
#  description       :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bank_account_id   :bigint           not null
#
# Indexes
#
#  index_transactions_on_bank_account_id  (bank_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (bank_account_id => bank_accounts.id)
#
FactoryBot.define do
  factory :transaction do
    bank_account
    counterparty_name { Faker::Company.name }
    counterparty_iban { Faker::Bank.iban }
    counterparty_bic { Faker::Bank.swift_bic }
    amount_cents { rand 9999 }
    amount_currency { rand 99_999 }
    description { Faker::Lorem.sentence }
  end
end
