# frozen_string_literal: true

include FactoryBot::Syntax::Methods

DatabaseCleaner.strategy = :truncation, { except: %w[public.schema_migrations] }
DatabaseCleaner.clean

create :bank_account,
       organization_name: 'ACME Corp',
       bic:               'OIVUSCLQXXX',
       iban:              'FR10474608000002006107XXXXX',
       balance_cents:     100_000
