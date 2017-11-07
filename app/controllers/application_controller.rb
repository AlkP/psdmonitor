class ApplicationController < ActionController::Base
  require 'ext/string'

  protect_from_forgery with: :exception
end
