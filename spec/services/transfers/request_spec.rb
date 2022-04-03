# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::Request, type: :dry_validation do
  describe 'Fields.' do
    subject { described_class.new }

    it { is_expected.to validate(:organization_name, :required).filled(:string) }
    it { is_expected.to validate(:organization_bic, :required).filled(:string) }
    it { is_expected.to validate(:organization_iban, :required).filled(:string) }
    it { is_expected.to validate(:credit_transfers, :required) }
  end

  describe 'Rules.' do
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

    let(:validator) { described_class.new.call(params) }

    context 'Organization BIC.' do
      let(:errors) { ['must contain 8 to 11 capital letters or numbers'] }

      subject { validator.errors.to_h[:organization_bic] }

      it { is_expected.to be_nil }

      context 'less than 8 characters' do
        let(:params) { super().merge(organization_bic: 'X' * 7) }

        it { is_expected.to eq(errors) }
      end

      context 'less than 8 characters' do
        let(:params) { super().merge(organization_bic: 'X' * 12) }

        it { is_expected.to eq(errors) }
      end

      context 'contains invalid character characters ' do
        let(:params) { super().merge(organization_bic: 'OIVUscLQXXX') }

        it { is_expected.to eq(errors) }
      end
    end

    context 'Organization IBAN.' do
      let(:errors) { ['must contain 15 to 34 capital letters or numbers'] }

      subject { validator.errors.to_h[:organization_iban] }

      it { is_expected.to be_nil }

      context 'less than 8 characters' do
        let(:params) { super().merge(organization_iban: 'X' * 14) }

        it { is_expected.to eq(errors) }
      end

      context 'less than 8 characters' do
        let(:params) { super().merge(organization_iban: 'X' * 35) }

        it { is_expected.to eq(errors) }
      end

      context 'contains invalid character characters' do
        let(:params) { super().merge(organization_iban: 'FR104.74608000002006107XXXX') }

        it { is_expected.to eq(errors) }
      end
    end

    context 'Credit transfers.' do
      subject { validator.errors.to_h[:credit_transfers] }

      context 'Credit transfers are valid.' do
        it { is_expected.to be_nil }
      end

      context 'Amount.' do
        it { is_expected.to be_nil }

        context 'The value is string of number.' do
          let(:credit_transfer) { super().merge(amount: '1.5') }

          it { is_expected.to be_nil }
        end

        context 'Amount must be a value of money.' do
          let(:credit_transfer) { super().merge(amount: '1.5444') }

          let(:errors) do
            {
              amount: { 0 => ['must be a number and contain the value of the amount of money'] }
            }
          end

          it { is_expected.to eq(errors) }
        end
      end

      context 'Currency.' do
        context 'The value is not EUR.' do
          let(:credit_transfer) { super().merge(currency: 'USD') }
          let(:errors) { { currency: { 0 => ['must be EUR'] } } }

          it { is_expected.to eq(errors) }
        end
      end

      context 'Organization BIC.' do
        let(:errors) do
          { counterparty_bic: { 0 => ['must contain 8 to 11 capital letters or numbers'] } }
        end

        it { is_expected.to be_nil }

        context 'less than 8 characters' do
          let(:credit_transfer) { super().merge(counterparty_bic: 'X' * 7) }

          it { is_expected.to eq(errors) }
        end

        context 'less than 8 characters' do
          let(:credit_transfer) { super().merge(counterparty_bic: 'X' * 12) }

          it { is_expected.to eq(errors) }
        end

        context 'contains invalid character characters' do
          let(:credit_transfer) { super().merge(counterparty_bic: 'OIVUscLQXXX') }

          it { is_expected.to eq(errors) }
        end
      end

      context 'Organization IBAN.' do
        let(:errors) do
          { counterparty_iban: { 0 => ['must contain 15 to 34 capital letters or numbers'] } }
        end

        it { is_expected.to be_nil }

        context 'less than 8 characters' do
          let(:credit_transfer) { super().merge(counterparty_iban: 'X' * 14) }

          it { is_expected.to eq(errors) }
        end

        context 'less than 8 characters' do
          let(:credit_transfer) { super().merge(counterparty_iban: 'X' * 35) }

          it { is_expected.to eq(errors) }
        end

        context 'contains invalid character characters' do
          let(:credit_transfer) { super().merge(counterparty_iban: 'fr10474608000002006107xxxx') }

          it { is_expected.to eq(errors) }
        end
      end
    end
  end
end
