# frozen_string_literal: true

require 'rails_helper'

RSpec.describe String do
  describe '#to_cents' do
    it { expect('14.53'.to_cents).to eq(1453) }
    it { expect('0.64'.to_cents).to eq(64) }
    it { expect('0.6477'.to_cents).to eq(0) }
    it { expect('wrong text'.to_cents).to eq(0) }
  end
end
