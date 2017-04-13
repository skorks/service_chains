require "service_chains/errors/service_failure"

module ServiceChains
  class ServiceChain
    attr_reader :services

    def initialize(services:)
      @services = services
    end

    def perform(service_context:)
      services.each do |service|
        begin
          service.perform(service_context: service_context)
        rescue ServiceChains::Errors::ServiceFailure
          service_context.record_service_failure(service)
        end

        break if service_context.failure?
      end
      service_context
    end
  end
end
