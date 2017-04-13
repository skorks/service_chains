module ServiceChains
  class ServiceContext
    class Errors
      attr_reader :error_hash

      def initialize
        @error_hash = {
          base: [],
        }
      end

      def message_list
        error_hash.map do |attribute, messages|
          if attribute == :base
            messages
          else
            messages.map do |message|
              message
            end
          end
        end.flatten
      end

      def messages_hash
        error_hash
      end

      def add_error(error)
        if error.kind_of?(String)
          add_error_for_attribute(:base, error)
        else
          add_error_for_attribute(:base, error.message)
        end
      end

      def add_error_for_attribute(attribute, message)
        attribute_symbol = attribute.to_sym
        error_hash[attribute_symbol] ||= []
        error_hash[attribute_symbol] << message
      end
    end
  end
end
