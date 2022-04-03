# frozen_string_literal: true

module Api
  module V1
    class TransfersController < ApplicationController
      def create
        head :created
      end

      private

      def transfer_params
        params.require(:transfer).permit(
          :organization_name, :organization_bic,
          :organization_iban, credit_transfers: %i[
            amount currency counterparty_name counterparty_bic
            counterparty_iban description
          ]
        )
      end
    end
  end
end
