module ServiceChains
  class ServiceContextMeta
    attr_reader :service_context

    def initialize(service_context)
      @service_context = service_context
    end

    def required_readers_present?(service_instance)
      (service_instance.class.instance_variable_get("@_context_attr_reader_method_names") || []).each do |method_name|
        reader_symbol = method_name.to_sym
        unless service_context.respond_to?(reader_symbol)
          raise "Service context must respond to '#{reader_symbol}'"
        end
      end
    end

    def required_writers_present?(service_instance)
      (service_instance.class.instance_variable_get("@_context_attr_writer_method_names") || []).each do |method_name|
        writer_symbol = "#{method_name}=".to_sym
        unless service_context.respond_to?(writer_symbol)
          raise "Service context must respond to '#{writer_symbol}'"
        end
      end
    end
  end
end
