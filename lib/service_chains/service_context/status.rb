module ServiceChains
  class ServiceContext
    class Status
      attr_reader :errors, :failed_services

      def initialize(errors)
        @failed_services = []
        @errors = errors
      end

      def record_service_failure(service)
        failed_services << service
      end

      def success?
        errors.message_list.count == 0 && failed_services.count == 0
      end

      def failure?
        !success?
      end
    end
  end
end
