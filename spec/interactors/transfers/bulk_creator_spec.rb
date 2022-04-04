# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::BulkCreator do
  describe '.call' do
    let(:interactors) { [::Transfers::Validator, ::Transfers::Creator] }

    it { expect(described_class.organized).to eq(interactors) }
  end
end
