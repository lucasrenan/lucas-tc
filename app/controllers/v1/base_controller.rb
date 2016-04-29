module V1
  class BaseController < ApplicationController
    include Authentication
    include ApiResponder::V1
    include Exceptions
    include Pundit
  end
end
