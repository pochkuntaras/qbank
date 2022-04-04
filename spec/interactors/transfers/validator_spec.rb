# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::Validator do
  let!(:bank_account) do
    create :bank_account,
           organization_name: 'ACME Corp',
           bic:               'OIVUSCLQXXX',
           iban:              'FR10474608000002006107XXXXX',
           balance_cents:     2_000
  end

  let(:params) { {} }
  let(:preparer) { ::Transfers::Preparer.new(params) }

  subject { described_class.call(preparer: preparer) }

  describe '.call' do
    before do
      allow(::Transfers::Preparer).to receive(:new).with(params).and_return(preparer)
      allow(preparer).to receive(:bank_account).and_return(bank_account)
    end

    context 'The request is valid.' do
      before { allow(preparer).to receive(:request_valid?).and_return(true) }

      context 'The account has funds for transfer.' do
        before do
          allow(preparer).to receive(:amount_cents).and_return(200)
          allow(preparer).to receive(:bank_account_balance).and_return(250)
        end

        it { expect(subject.success?).to eq(true) }
        it { expect(subject.message).to eq('Request is prepared for processing') }
        it { expect(subject.status).to eq(:processing) }
      end

      context 'The account has not funds for transfer.' do
        before do
          allow(preparer).to receive(:amount_cents).and_return(300)
          allow(preparer).to receive(:bank_account_balance).and_return(250)
        end

        it { expect(subject.failure?).to eq(true) }
        it { expect(subject.message).to eq('The account has not funds for transfer') }
        it { expect(subject.status).to eq(:unprocessable_entity) }
      end
    end

    context 'The request is not valid.' do
      let(:credit_transfer) { super().merge(amount: '') }

      it { expect(subject.failure?).to eq(true) }
      it { expect(subject.message).to eq('The transfer request is invalid') }
      it { expect(subject.errors).to eq(preparer.request.errors.to_h) }
      it { expect(subject.status).to eq(:bad_request) }
    end

    context 'Bank account was not found.' do
      before do
        allow(preparer).to receive(:request_valid?).and_return(true)
        allow(preparer).to receive(:bank_account).and_return(nil)
      end

      it { expect(subject.failure?).to eq(true) }
      it { expect(subject.message).to eq('Bank account was not found') }
      it { expect(subject.status).to eq(:not_found) }
    end
  end
end
