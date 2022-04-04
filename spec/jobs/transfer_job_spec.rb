# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferJob, type: :job do
  let!(:bank_account) { create :bank_account, balance_cents: 1_000 }

  let(:first_credit_transfer) do
    {
      amount_cents:      145,
      counterparty_name: 'Bip Bip',
      counterparty_bic:  'CRLYFRPPTOU',
      counterparty_iban: 'EE383680981021245685',
      description:       'Wonderland/4410'
    }
  end

  let(:second_credit_transfer) do
    {
      amount_cents:      612,
      counterparty_name: 'Wile E Coyote',
      counterparty_bic:  'ZDRPLBQI',
      counterparty_iban: 'DE9935420810036209081725212',
      description:       '//TeslaMotors/Invoice/12'
    }
  end

  let(:transaction_params) { [first_credit_transfer, second_credit_transfer] }

  subject { described_class.perform_now(bank_account.id, transaction_params) }

  describe '.perform_now' do
    it { expect { subject }.to change(bank_account.transactions, :count).by(2) }

    it 'should change bank account balance' do
      expect {
        subject
        bank_account.reload
      }.to change(bank_account, :balance_cents).from(1_000).to(243)
    end

    context 'Save transactions with params.' do
      it { expect(::Transaction).to receive(:upsert_all).with(transaction_params) }

      after { subject }
    end

    context 'The account has not funds for transfer' do
      let!(:bank_account) { create :bank_account, balance_cents: 100 }

      let(:error) { [StandardError, 'The account has not funds for transfer'] }

      it { expect { subject }.to raise_error(*error) }
    end

    context 'Rollback transfer when something wrong.' do
      let(:error) { ActiveRecord::RecordInvalid.new }

      before do
        allow(::BankAccount).to receive(:find).with(bank_account.id).and_return(bank_account)
        allow(bank_account).to receive(:update!).and_raise(error)
      end

      it { expect { subject rescue nil }.to_not change(::Transaction, :count) }
    end
  end
end
