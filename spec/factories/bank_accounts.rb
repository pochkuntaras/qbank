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
FactoryBot.define do
  factory :bank_account do
    organization_name { Faker::Company.name }
    balance_cents { rand 9999999 }
    iban { Faker::Bank.iban }
    bic { Faker::Bank.swift_bic }
  end
end
