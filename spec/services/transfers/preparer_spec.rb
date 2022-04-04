# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::Preparer do
  let!(:bank_account) do
    create :bank_account,
           organization_name: 'ACME Corp',
           bic:               'OIVUSCLQXXX',
           iban:              'FR10474608000002006107XXXXX',
           balance_cents:     2000
  end

  let(:first_credit_transfer) do
    {
      amount:            14.5,
      currency:          'EUR',
      counterparty_name: 'Bip Bip',
      counterparty_bic:  'CRLYFRPPTOU',
      counterparty_iban: 'EE383680981021245685',
      description:       'Wonderland/4410'
    }
  end

  let(:second_credit_transfer) do
    {
      amount:            '61238',
      currency:          'EUR',
      counterparty_name: 'Wile E Coyote',
      counterparty_bic:  'ZDRPLBQI',
      counterparty_iban: 'DE9935420810036209081725212',
      description:       '//TeslaMotors/Invoice/12'
    }
  end

  let(:params) do
    {
      organization_name: 'ACME Corp',
      organization_bic:  'OIVUSCLQXXX',
      organization_iban: 'FR10474608000002006107XXXXX',
      credit_transfers:  [first_credit_transfer, second_credit_transfer]
    }
  end

  let(:transfer_request) { ::Transfers::Request.new }

  subject { described_class.new(params) }

  describe '#request_valid?' do
    before { allow(::Transfers::Request).to receive(:new).and_return(transfer_request) }

    it { expect(transfer_request).to receive_message_chain(call: params, success?: nil) }

    after { subject.request_valid? }
  end

  describe '#transaction_params' do
    let(:transaction_params) do
      [
        {
          amount_cents:      1450,
          counterparty_name: 'Bip Bip',
          counterparty_bic:  'CRLYFRPPTOU',
          counterparty_iban: 'EE383680981021245685',
          description:       'Wonderland/4410'
        },
        {
          amount_cents:      61_238,
          counterparty_name: 'Wile E Coyote',
          counterparty_bic:  'ZDRPLBQI',
          counterparty_iban: 'DE9935420810036209081725212',
          description:       '//TeslaMotors/Invoice/12'
        }
      ]
    end

    it { expect(subject.transaction_params).to match_array(transaction_params) }
  end

  describe '#amount_cents' do
    it { expect(subject.amount_cents).to eq(62_688) }
  end

  describe '#bank_account' do
    it { expect(subject.bank_account).to eq(bank_account) }
  end

  describe '#bank_account_balance' do
    it { expect(subject.bank_account_balance).to eq(bank_account.balance_cents) }
  end
end
