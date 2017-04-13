module ServiceChains
  class InlineBlockService
    attr_reader :block

    def initialize(&block)
      @block = block
    end

    def perform(service_context:)
      block.call(service_context)
    end
  end
end
