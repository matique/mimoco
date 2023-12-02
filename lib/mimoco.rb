require "minitest"
require "mimoco_base"
require "mimoco_models"
require "mimoco_controllers"

module Minitest
  module Checks
    def check_models(data)
      Models.run data, self
#      Minitest::Checks::Models.run data, self
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
