# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::Creator do
  let!(:bank_account) do
    create :bank_account,
           organization_name: 'ACME Corp',
           bic:               'OIVUSCLQXXX',
           iban:              'FR10474608000002006107XXXXX',
           balance_cents:     200_000
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

  let(:credit_transfers) { [first_credit_transfer, second_credit_transfer] }

  let(:params) do
    {
      organization_name: 'ACME Corp',
      organization_bic:  'OIVUSCLQXXX',
      organization_iban: 'FR10474608000002006107XXXXX',
      credit_transfers:  credit_transfers
    }
  end

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

  let(:preparer) { ::Transfers::Preparer.new(params) }

  subject { described_class.call(preparer: preparer) }

  describe '.call' do
    it { expect(subject.message).to eq('The transfer was success created') }
    it { expect(subject.status).to eq(:created) }

    context 'Perform transfer job.' do
      before { allow(::Transfers::Preparer).to receive(:new).with(params).and_return(preparer) }

      it { expect(::TransferJob).to receive(:perform_later).with(bank_account.id, transaction_params) }

      after { subject }
    end
  end
end
