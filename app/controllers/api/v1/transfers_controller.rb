# frozen_string_literal: true

module Api
  module V1
    class TransfersController < ApplicationController
      def create
        render json: create_response_json, status: creator.status
      end

      private

      def transfer_params
        params.require(:transfer).permit(
          :organization_name, :organization_bic,
          :organization_iban, credit_transfers: %i[
            amount currency counterparty_name counterparty_bic
            counterparty_iban description
          ]
        ).to_h
      end

      def preparer
        @preparer ||= ::Transfers::Preparer.new(transfer_params)
      end

      def creator
        @creator ||= ::Transfers::BulkCreator.call(preparer: preparer)
      end

      def create_response_json
        { message: creator.message, errors: creator.errors }.compact
      end
    end
  end
end
