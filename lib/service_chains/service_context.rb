require "service_chains/service_context/status"
require "service_chains/service_context/errors"

module ServiceChains
  class ServiceContext
    extend Forwardable

    attr_reader :_data, :_errors, :_status

    def_delegators :_errors, :message_list, :message_hash, :add_error, :add_error_for_attribute
    def_delegators :_status, :success?, :failure?, :record_service_failure

    def initialize(data = {})
      @_data = data
      @_errors = Errors.new
      @_status = Status.new(@_errors)

      define_accessors_for_data_keys
    end

    private

    def define_accessors_for_data_keys
      @_data.each_key do |key|
        # do nothing if method is already defined
        next if respond_to?(key.to_sym)

        define_singleton_method key, -> { @_data[key] }
        define_singleton_method "#{key}=".to_sym, ->(value) { @_data[key] = value }
      end
    end
  end
end
