# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::Validator do
  subject { described_class.call(params: params) }

  let(:credit_transfer) do
    {
      amount:            14.5,
      currency:          'EUR',
      counterparty_name: 'Bip Bip',
      counterparty_bic:  'CRLYFRPPTOU',
      counterparty_iban: 'EE383680981021245685',
      description:       'Wonderland/4410'
    }
  end

  let(:params) do
    {
      organization_name: 'ACME Corp',
      organization_bic:  'OIVUSCLQXXX',
      organization_iban: 'FR10474608000002006107XXXXX',
      credit_transfers:  [credit_transfer]
    }
  end

  let(:transfer) { ::Transfers::Request.new }

  describe '.call' do
    context 'Validate transfer request.' do
      before { allow(::Transfers::Request).to receive(:new).and_return(transfer) }

      it { expect(transfer).to receive(:call).with(params).and_call_original }

      after { subject }
    end

    context 'The request is valid.' do
      let!(:bank_account) do
        create :bank_account,
               organization_name: 'ACME Corp',
               bic:               'OIVUSCLQXXX',
               iban:              'FR10474608000002006107XXXXX',
               balance_cents:     2000
      end

      it { expect(subject.success?).to eq(true) }
    end

    context 'The request is not valid.' do
      let(:credit_transfer) { super().merge(amount: '') }

      it { expect(subject.failure?).to eq(true) }

      context 'The request errors.' do
        let(:request) { transfer.call(params) }

        before do
          allow(::Transfers::Request).to receive_message_chain(new: nil, call: params).and_return(request)
        end

        it { expect(subject.message).to eq('The transfer request is invalid') }
        it { expect(subject.errors).to eq(request.errors.to_h) }
      end
    end

    context 'Validate funds.' do
      let!(:bank_account) do
        create :bank_account,
               organization_name: 'ACME Corp',
               bic:               'OIVUSCLQXXX',
               iban:              'FR10474608000002006107XXXXX',
               balance_cents:     2000
      end

      context 'The request is valid.' do
        it { expect(subject.success?).to eq(true) }
      end

      context 'The account has not funds for transfer.' do
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
          super().merge(
            credit_transfers: [credit_transfer, second_credit_transfer]
          )
        end

        it { expect(subject.failure?).to eq(true) }

        context 'The request errors.' do
          let(:request) { transfer.call(params) }

          before do
            allow(::Transfers::Request).to receive_message_chain(new: nil, call: params).and_return(request)
          end

          it { expect(subject.message).to eq('The account has not funds for transfer') }
        end
      end
    end
  end
end
