# frozen_string_literal: true

class TransferJob < ApplicationJob
  queue_as :default

  attr_reader :bank_account_id, :transaction_params

  def perform(bank_account_id, transaction_params)
    @bank_account_id    = bank_account_id
    @transaction_params = transaction_params

    validate_balance!

    ActiveRecord::Base.transaction do
      bank_account.transactions.upsert_all(transaction_params)
      bank_account.update!(balance_cents: bank_account.balance_cents - amount_cents)
    end
  end

  private

  def bank_account
    @bank_account ||= ::BankAccount.find(bank_account_id)
  end

  def amount_cents
    @amount_cents ||= transaction_params.map { |transfer| transfer[:amount_cents] }.sum
  end

  def validate_balance!
    return if bank_account.balance_cents > amount_cents

    raise StandardError, 'The account has not funds for transfer'
  end
end
