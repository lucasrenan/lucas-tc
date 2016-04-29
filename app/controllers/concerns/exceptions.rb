module Exceptions
  class NotAuthenticated < StandardError
    def message
      'Not authenticated'
    end
  end
end
