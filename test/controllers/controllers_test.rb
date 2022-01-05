require "test_helper"
require "mimoco"
#require "mimoco_controllers"

class ControllersTest < ActionDispatch::IntegrationTest
  def test_some
    controllers = {
      OrdersController => {
#        valid: {name: "Name", qty: 123},
#        invalid: {qty: :abc},
#        class_methods: %i[class_method],
#        call_class_methods: %i[class_method],
        public_methods: %i[create destroy edit index new show update],
#        call_public_methods: %i[public_method]
      }
    }
    check_controllers controllers
  end

#  def test_valid
#    models = {Order => {valid: {name: "Name", qty: 123}}}
#    check_models models
#  end
#
#  def test_valids
#    models = {
#      Order => {
#        valids: [
#          {name: "Name", qty: 123},
#          {qty: 123}
#        ]
#      }
#    }
#    check_models models
#  end
#
#  def test_some
#    models = {
#      Order => {
#        valid: {name: "Name", qty: 123},
#        invalid: {qty: :abc},
#        class_methods: %i[class_method],
#        call_class_methods: %i[class_method],
#        public_methods: %i[public_method],
#        call_public_methods: %i[public_method]
#      }
#    }
#    check_models models
#  end
end
