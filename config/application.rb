# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Qbank
  class Application < Rails::Application
    config.load_defaults 7.0

    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec, fixtures: true, view_specs: false,
                       helper_specs:     false, routing_specs: false,
                       request_specs:    false, controller_specs: true

      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.active_job.queue_adapter = :sidekiq
  end
end
