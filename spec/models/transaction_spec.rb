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
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { is_expected.to belong_to(:bank_account).required(true) }

  it { is_expected.to validate_presence_of :amount_cents }
  it { is_expected.to validate_presence_of :amount_currency }
  it { is_expected.to validate_presence_of :counterparty_bic }
  it { is_expected.to validate_presence_of :counterparty_iban }
  it { is_expected.to validate_presence_of :counterparty_name }
  it { is_expected.to validate_presence_of :description }

  it { is_expected.to validate_numericality_of(:amount_cents).only_integer.is_greater_than(0) }

  it { is_expected.to validate_length_of(:counterparty_bic).is_at_least(8).is_at_most(11) }
  it { is_expected.to validate_length_of(:counterparty_iban).is_at_least(15).is_at_most(34) }

  context 'Amount currency.' do
    it { is_expected.to validate_length_of(:amount_currency).is_equal_to(3) }

    it { is_expected.to allow_value('EUR').for(:amount_currency) }

    it { is_expected.to_not allow_value('eur').for(:amount_currency) }
    it { is_expected.to_not allow_value('eUr').for(:amount_currency) }
  end
end
