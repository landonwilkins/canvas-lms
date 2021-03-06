require 'text_helper'
require 'canvas/lock_explanation'
require 'active_model_serializers'
require 'action_controller'
require 'active_support'
require 'active_record'
require 'mocha/api'
require File.expand_path(File.dirname(__FILE__) +  '/../vendor/plugins/sanitize_field/lib/sanitize_field')
require 'api'

# You can include just this file if your serializer doesn't need too much
# from the whole stack to run your tests faster!

module ActiveModel
  class FakeController
    if CANVAS_RAILS2
      include ActionController::PolymorphicRoutes
      include ActionController::UrlWriter
      self.default_url_options[:host] = 'example.com'
    else
      include Rails.application.routes.url_helpers
      def default_url_options
        { host: 'example.com' }
      end
    end

    attr_accessor :accepts_jsonapi, :stringify_json_ids, :session, :context

    def initialize(options={})
      @accepts_jsonapi = options.fetch(:accepts_jsonapi, true)
      @stringify_json_ids = options.fetch(:stringify_json_ids, true)
      @session = options[:session]
      @context = options[:context]
    end

    def accepts_jsonapi?
      !!accepts_jsonapi
    end

    def stringify_json_ids?
      !!stringify_json_ids
    end

  end
end

Dir[File.expand_path(File.dirname(__FILE__) + '/../app/serializers/*.rb')].each do |file|
  require file
end
