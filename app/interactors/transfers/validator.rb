# frozen_string_literal: true

module Transfers
  class Validator
    include Interactor
    include Interactor::Contracts

    expects do
      required(:preparer).value(type?: ::Transfers::Preparer).filled
    end

    promises do
      required(:message)
      required(:status)

      optional(:errors)
    end

    def call
      validate_syntax!
      validate_bank_account!
      validate_balance!

      context.message = 'Request is prepared for processing'
      context.status  = :processing
    end

    private

    def request
      @request ||= ::Transfers::Request.new.call(context.params)
    end

    def validate_bank_account!
      return if context.preparer.bank_account.present?

      context.fail!(
        message: 'Bank account was not found',
        status:  :not_found
      )
    end

    def validate_syntax!
      return if context.preparer.request_valid?

      context.fail!(
        message: 'The transfer request is invalid',
        errors:  context.preparer.request.errors.to_h,
        status:  :bad_request
      )
    end

    def validate_balance!
      return if context.preparer.bank_account_balance > context.preparer.amount_cents

      context.fail!(
        message: 'The account has not funds for transfer',
        status:  :unprocessable_entity
      )
    end
  end
end
