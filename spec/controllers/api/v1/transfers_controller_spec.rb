# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransfersController, type: :controller do
  describe 'GET #create' do
    let(:params) do
      {
        organization_name: 'ACME Corp',
        organization_bic:  'OIVUSCLQXXX',
        organization_iban: 'FR10474608000002006107XXXXX',
        credit_transfers:  [
          {
            amount:            '14.5',
            currency:          'EUR',
            counterparty_name: 'Bip Bip',
            counterparty_bic:  'CRLYFRPPTOU',
            counterparty_iban: 'EE383680981021245685',
            description:       'Wonderland/4410'
          },
          {
            amount:            '61238',
            currency:          'EUR',
            counterparty_name: 'Wile E Coyote',
            counterparty_bic:  'ZDRPLBQI',
            counterparty_iban: 'DE9935420810036209081725212',
            description:       '//TeslaMotors/Invoice/12'
          },
          {
            amount:            '999',
            currency:          'EUR',
            counterparty_name: 'Bugs Bunny',
            counterparty_bic:  'RNJZNTMC',
            counterparty_iban: 'FR0010009380540930414023042',
            description:       '2020 09 24/2020 09 25/GoldenCarrot/'
          }
        ]
      }
    end

    let(:bank_account_params) do
      {
        organization_name: 'ACME Corp',
        bic:               'OIVUSCLQXXX',
        iban:              'FR10474608000002006107XXXXX',
        balance_cents:     1_000
      }
    end

    context 'Bank account was not found.' do
      let(:message) { 'Bank account was not found' }

      before { do_request transfer: params }

      it { expect(response.body).to be_json_eql(message.to_json).at_path('message') }
      it { expect(response).to have_http_status(:not_found) }
    end

    context 'The request is not valid.' do
      let(:message) { 'The transfer request is invalid' }
      let(:errors) { { organization_bic: ['must be filled'] } }
      let(:params) { super().merge(organization_bic: '') }

      before { do_request transfer: params }

      it { expect(response.body).to be_json_eql(errors.to_json).at_path('errors') }
      it { expect(response.body).to be_json_eql(message.to_json).at_path('message') }
      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'The account has not funds for transfer.' do
      let(:message) { 'The account has not funds for transfer' }
      let!(:bank_account) { create :bank_account, bank_account_params }

      before { do_request transfer: params }

      it { expect(response.body).to be_json_eql(message.to_json).at_path('message') }
      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    describe 'Success.' do
      let(:message) { 'The transfer was success created' }
      let(:bank_account_params) { super().merge(balance_cents: 100_000) }

      let!(:bank_account) { create :bank_account, bank_account_params }

      it { expect { do_request transfer: params }.to change(bank_account.transactions, :count).by(3) }

      it 'should change bank account balance' do
        expect {
          do_request transfer: params
          bank_account.reload
        }.to change(bank_account, :balance_cents).by(-63687)
      end

      context 'Response.' do
        before { do_request transfer: params }

        it { expect(response.body).to be_json_eql(message.to_json).at_path('message') }
        it { expect(response).to have_http_status(:created) }
      end
    end

    def do_request(params = {})
      get :create, params: params
    end
  end
end
