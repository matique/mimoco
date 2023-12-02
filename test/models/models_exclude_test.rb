require "test_helper"
require "mimoco"

class ModelsTest < Minitest::Test
  def test_public_methods
    models = {Order => {public_methods: %i[public_method]}}
    check_models models, exclude_public_methods: %i[public_method]
  end

#  def test_call_public_methods
#    models = {
#      Order => {
#        valid: {name: "Name", qty: 123},
#        call_public_methods: %i[public_method]
#      }
#    }
#    check_models models
#  end
#
#  def test_several
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
