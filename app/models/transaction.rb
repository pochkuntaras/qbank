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
class Transaction < ApplicationRecord
  belongs_to :bank_account, required: true

  validates :amount_cents, :amount_currency, :amount_currency,
            :counterparty_bic, :counterparty_iban, :counterparty_name,
            :description, presence: true

  validates :amount_cents, numericality: { greater_than: 0, only_integer: true }
  validates :amount_currency, length: { is: 3 }, format: { with: /\A[A-Z]{3}\z/ }
  validates :counterparty_bic, length: { in: 8..11 }
  validates :counterparty_iban, length: { in: 15..34 }
end
