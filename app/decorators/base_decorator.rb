class BaseDecorator < SimpleDelegator
  def object
    __getobj__
  end
end
