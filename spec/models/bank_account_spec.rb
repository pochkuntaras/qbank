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
require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  subject { create :bank_account }

  it { is_expected.to have_many(:transactions).dependent(:destroy) }

  it { is_expected.to validate_presence_of :balance_cents }
  it { is_expected.to validate_presence_of :bic }
  it { is_expected.to validate_presence_of :iban }
  it { is_expected.to validate_presence_of :organization_name }

  it { is_expected.to validate_numericality_of(:balance_cents).only_integer.is_greater_than(0) }

  it { is_expected.to validate_uniqueness_of :bic }
  it { is_expected.to validate_uniqueness_of :iban }

  it { is_expected.to validate_length_of(:bic).is_at_least(8).is_at_most(11) }
  it { is_expected.to validate_length_of(:iban).is_at_least(15).is_at_most(34) }
end
