
module CurrentRequest

  def self.included( base )
    base.send( :include, CurrentRequest::InstanceMethods )
    base.before_filter :_set_current_request
    base.after_filter :_unset_current_request
  end

  module InstanceMethods

    def _set_current_request
      Thread.current[:_current_request] = request
    end

    def _unset_current_request
      Thread.current[:_current_request] = nil
      true
    end

  end

  class Holder

    def self.current_request
      Thread.current[:_current_request]
    end

  end

end

ActionController::Base.class_eval do
  include CurrentRequest
end

ActionView::Base.class_eval do

  def current_request
    Thread.current[:_current_request]
  end

  def current_host
    "#{current_request.protocol}#{current_request.host_with_port}"
  end

end