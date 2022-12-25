require "test_helper"
require "mimoco"

class ControllersTest < ActionDispatch::IntegrationTest
  def test_some
    controllers = {
      OrdersController => {
        respond_to: %i[create destroy edit index new show update],
        class_methods: %i[class_method],
        call_class_methods: %i[class_method],
        public_methods: %i[create destroy edit index new show update]
      }
    }

    check_controllers controllers
  end
end
