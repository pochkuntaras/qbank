# frozen_string_literal: true

module Transfers
  class Request < Dry::Validation::Contract
    AMOUNT_FORMAT   = /\A\d+(\.\d{,2})?\z/
    BIC_FORMAT      = /\A[A-Z0-9]{8,11}\z/
    IBAN_FORMAT     = /\A[A-Z0-9]{15,34}\z/
    CURRENCY_FORMAT = /\AEUR\z/

    params do
      required(:organization_name).filled(:string)
      required(:organization_bic).filled(:string)
      required(:organization_iban).filled(:string)

      required(:credit_transfers).value(:array, min_size?: 1).each do
        hash do
          required(:amount).filled
          required(:currency).filled(:string)
          required(:counterparty_name).filled(:string)
          required(:counterparty_bic).filled(:string)
          required(:counterparty_iban).filled(:string)
          required(:description).filled(:string)
        end
      end
    end

    rule(:organization_bic) { validate_bic key, value }
    rule(:organization_iban) { validate_iban key, value }

    rule(:credit_transfers).each do |index:|
      validate_amount(key([:credit_transfers, :amount, index]), value[:amount])
      validate_currency(key([:credit_transfers, :currency, index]), value[:currency])
      validate_bic(key([:credit_transfers, :counterparty_bic, index]), value[:counterparty_bic])
      validate_iban(key([:credit_transfers, :counterparty_iban, index]), value[:counterparty_iban])
    end

    private

    def validate_bic(key, value)
      key.failure('must contain 8 to 11 capital letters or numbers') unless value.to_s =~ BIC_FORMAT
    end

    def validate_iban(key, value)
      key.failure('must contain 15 to 34 capital letters or numbers') unless value.to_s =~ IBAN_FORMAT
    end

    def validate_amount(key, value)
      key.failure('must be a number and contain the value of the amount of money') unless value.to_s =~ AMOUNT_FORMAT
    end

    def validate_currency(key, value)
      key.failure('must be EUR') unless value.to_s =~ CURRENCY_FORMAT
    end
  end
end
