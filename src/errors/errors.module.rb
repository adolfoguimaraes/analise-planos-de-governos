module Errors
  class BaseError < StandardError
    def initialize(msg = 'Exception error', exception_type = 'custom')
      @exception_type = exception_type
      super(msg)
    end
  end
end
