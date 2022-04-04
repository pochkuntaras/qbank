# frozen_string_literal: true

module Transfers
  class Creator
    include Interactor
    include Interactor::Contracts

    expects do
      required(:preparer).value(type?: ::Transfers::Preparer).filled
    end

    promises do
      required(:message)
      required(:status)
    end

    def call
      ::TransferJob.perform_later(
        context.preparer.bank_account&.id,
        context.preparer.transaction_params
      )

      context.message = 'The transfer was success created'
      context.status  = :created
    rescue StandardError => e
      context.fail!(message: e.message, status: :internal_server_error)
    end
  end
end
