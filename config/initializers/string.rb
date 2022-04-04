# frozen_string_literal: true

class String
  MONEY_FORMAT = /\A\d+\.\d{,2}\z/

  def to_cents
    self =~ MONEY_FORMAT ? (to_f * 100).to_i : to_i
  end
end
