class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :mobile?

  def mobile?
    browser.device.mobile?
  end
  helper_method :mobile?
end
