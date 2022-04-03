# frozen_string_literal: true

module Transfers
  class Validator
    EURO_FORMAT = /\A\d+\.\d{,2}\z/
    CENT_FORMAT = /\A\d+\z/

    include Interactor
    include Interactor::Contracts

    expects do
      required(:params).filled
    end

    def call
      validate_request!
    end

    private

    %i[organization_bic organization_iban credit_transfers].each do |field_name|
      define_method(field_name) do
        request[field_name]
      end
    end

    def transfer
      @transfer ||= ::Transfers::Request.new
    end

    def request
      @request ||= transfer.call(context.params)
    end

    def validate_syntax!
      return if request.success?

      context.fail!(
        message: 'The transfer request is invalid',
        errors:  request.errors.to_h
      )
    end

    def validate_request!
      validate_syntax!
      validate_funds!
    end

    def bank_account
      @bank_account ||= ::BankAccount
                        .where(bic: organization_bic)
                        .or(::BankAccount.where(iban: organization_iban))
                        .take
    end

    def sum_transfer_euro
      return 0 if credit_transfers.blank?

      credit_transfers.map do |transfer|
        return (transfer[:amount].to_f * 100).round if transfer[:amount] =~ EURO_FORMAT
        return transfer[:amount].to_i if transfer[:amount] =~ CENT_FORMAT

        0
      end.sum
    end

    def validate_funds!
      return if bank_account&.balance_cents.to_i > sum_transfer_euro

      context.fail!(message: 'The account has not funds for transfer')
    end
  end
end
