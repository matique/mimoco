require "minitest"
require "mimoco_base"
require "mimoco_valid"
require "mimoco_models"
require "mimoco_controllers"

module Minitest
  module Checks
# def t(*args, **kwargs)
#   proc { I18n.t(*args, **kwargs) }
# end
#    def check_models(data)
#    def check_models(data, *args, **kwargs)
    def check_models(data, **kwargs)
#ic args
ic kwargs
      Models.run data, self
    end

    def check_controllers(data)
      Controllers.run data, self
    end

    class ValidMissingError < StandardError; end
  end

  class Test
    include Checks
  end
end
