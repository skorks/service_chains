require 'service_chains/errors/error'

module ServiceChains
  module Errors
    class BaseError < StandardError
      include Error
    end
  end
end
