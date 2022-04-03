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
class BankAccountSerializer < ActiveModel::Serializer
  attributes :organization_name, :iban, :bic, :balance_cents
end
