module V1
  class BaseController < ApplicationController
    include ApiResponder::V1
    include Exceptions
  end
end
