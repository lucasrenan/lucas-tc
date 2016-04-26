module Exceptions
  class NotAuthorized < StandardError
    def message
      'not authorized'
    end
  end
end
