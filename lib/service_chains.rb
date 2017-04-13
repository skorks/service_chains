require "service_chains/version"
require "service_chains/service_context"
require "service_chains/chainable_service"
require "service_chains/service_chain"
require "service_chains/errors/service_failure"

module ServiceChains
  class << self
    def perform(services, service_context = ServiceContext.new)
      service_chain = ServiceChains::ServiceChain.new(services: services)
      service_chain.perform(service_context: service_context)
    end

    def service(&block)
      InlineBlockService.new(&block)
    end
  end
end
#
# class FooService
#   include ServiceChains::ChainableService
#
#   context_attr_reader :blah
#   context_attr_writer :yadda
#
#   def perform
#     p blah
#     service_context.yadda = blah
#   end
# end
#
# class BarService
#   include ServiceChains::ChainableService
#
#   def perform
#     # raise ServiceChains::Errors::ServiceFailure
#     service_context.add_error("Hello error")
#   end
# end
#
# class Main
#   def execute
#     service_context = ServiceChains::ServiceContext.new({
#       blah: "5",
#       yadda: nil,
#     })
#
#     service_chain = ServiceChains::ServiceChain.new(services: [
#       FooService,
#       BarService,
#     ])
#
#     service_chain.perform(service_context: service_context)
#
#     p service_context
#     p service_context.success?
#   end
# end
#
# service_chain = ServiceChains::ServiceChain.new(services: [
#   ServiceChains.service do |service_context|
#     if service_context.blah == "5"
#       ServiceChains.perform([
#         FooService,
#         BaxService,
#         ClabService,
#       ], service_context)
#     else
#       ServiceChains.perform([
#         BarService,
#         FoozService,
#         DoofService,
#       ], service_context)
#     end
#   end
# ])
