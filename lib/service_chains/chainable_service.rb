require "service_chains/service_context_meta"
require 'service_chains/errors/client_error'

module ServiceChains
  module ChainableService
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def context_attr_reader(*method_names)
        @_context_attr_reader_method_names = method_names

        (@_context_attr_reader_method_names || []).each do |method_name|
          reader_symbol = method_name.to_sym
          define_method reader_symbol do
            @service_context.send(reader_symbol)
          end
        end
      end

      def context_attr_writer(*method_names)
        @_context_attr_writer_method_names = method_names

        (@_context_attr_writer_method_names || []).each do |method_name|
          reader_symbol = method_name.to_sym
          define_method reader_symbol do
            @service_context.send(reader_symbol)
          end
          writer_symbol = "#{method_name}=".to_sym
          define_method writer_symbol do |value|
            @service_context.send(writer_symbol, value)
          end
        end
      end

      def required_inputs
        @_context_attr_reader_method_names
      end

      def expected_outputs
        @_context_attr_writer_method_names
      end

      def perform(options = {})
        service_context = options[:service_context] || ServiceContext.new(options)
        service = new(service_context: service_context)
        service.perform
        service_context
      end
    end

    attr_reader :service_context

    def initialize(service_context:)
      @service_context = service_context
      ServiceContextMeta.new(service_context).required_readers_present?(self)
      ServiceContextMeta.new(service_context).required_writers_present?(self)
    end

    def perform
      raise Errors::ClientError.new("Chainable services must override the 'perform' method.")
    end
  end
end
