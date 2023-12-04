require "test_helper"
require "mimoco"

class ModelsIgnoreTest < Minitest::Test
  def test_no_ignore_class_methods
    models = {Order => {class_methods: %i[class_method]}}
    check_models models
  end

  def test_ignore_class_methods
    models = {Order => {class_methods: %i[]}}
    check_models models, ignore_methods: :class_method
  end

  def test_no_ignore_public_methods
    models = {Order => {public_methods: %i[public_method]}}
    check_models models
  end

  def test_ignore_public_methods
    models = {Order => {public_methods: %i[]}}
    check_models models, ignore_methods: :public_method
  end

  def test_controllers_no_ignore_class_methods
    controllers = {OrdersController => {class_methods: %i[class_method]}}
    check_controllers controllers
  end

  def test_controllers_ignore_class_methods
    controllers = {OrdersController => {class_methods: %i[]}}
    check_controllers controllers, ignore_methods: :class_method
  end
end
