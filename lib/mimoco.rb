require "minitest"
require "mimoco_base"
require "mimoco_valid"
require "mimoco_models"
require "mimoco_controllers"

module Minitest
  module Checks
#    def check_models(data, *args, **kwargs)
    def check_models(data, ignore_methods: nil)
      Models.run data, self, ignore_methods
    end

#    def check_controllers(data)
    def check_controllers(data, ignore_methods: nil)
      Controllers.run data, self, ignore_methods
    end

    class ValidMissingError < StandardError; end
  end

  class Test
    include Checks
  end
end
