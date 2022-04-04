# frozen_string_literal: true

module Transfers
  class BulkCreator
    include Interactor::Organizer

    organize ::Transfers::Validator, ::Transfers::Creator
  end
end
