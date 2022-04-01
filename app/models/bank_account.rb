# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_accounts
#
#  id                :bigint           not null, primary key
#  balance_cents     :integer          default(0), not null
#  bic               :string(11)       not null
#  iban              :string(34)       not null
#  organization_name :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_bank_accounts_on_bic   (bic) UNIQUE
#  index_bank_accounts_on_iban  (iban) UNIQUE
#
class BankAccount < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :balance_cents, :bic, :iban, :organization_name, presence: true
  validates :balance_cents, numericality: { greater_than: 0, only_integer: true }
  validates :bic, length: { in: 8..11 }, uniqueness: { case_sensitive: true }
  validates :iban, length: { in: 15..34 }, uniqueness: { case_sensitive: true }
end
