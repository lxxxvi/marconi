module FactDecoratable
  extend ActiveSupport::Concern

  included do
    def decorated_value
      decorate.value
    end

    def decorate
      @decorate ||= FactDecorator.new(self)
    end
  end
end
