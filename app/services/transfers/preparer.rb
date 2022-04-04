# frozen_string_literal: true

module Transfers
  class Preparer
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def request
      @request ||= ::Transfers::Request.new.call(params)
    end

    def request_valid?
      request.success?
    end

    def transaction_params
      @transaction_params ||= request[:credit_transfers].map do |transfer|
        {
          counterparty_name: transfer[:counterparty_name],
          counterparty_bic:  transfer[:counterparty_bic],
          counterparty_iban: transfer[:counterparty_iban],
          amount_cents:      transfer[:amount].to_s.to_cents,
          description:       transfer[:description]
        }
      end
    end

    def amount_cents
      @amount_cents ||= transaction_params.map { |transfer| transfer[:amount_cents] }.sum
    end

    def bank_account
      @bank_account ||= ::BankAccount.where(bic: bic).or(::BankAccount.where(iban: iban)).take
    end

    def bank_account_balance
      bank_account&.balance_cents.to_i
    end

    private

    def bic
      request[:organization_bic]
    end

    def iban
      request[:organization_iban]
    end
  end
end
