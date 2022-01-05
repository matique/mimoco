require "test_helper"
require "mimoco"

class ModelsTest < Minitest::Test
  def test_valid
    models = {Order => {valid: {name: "Name", qty: 123}}}
#    models = {Order => {valid: {name: "Name", qty: :abc}}}
    check_models models
  end

  def test_valids
    models = {
      Order => {
        valids: [
          {name: "Name", qty: 123},
          {qty: 123}
        ]
      }
    }
    check_models models
  end

  def test_invalid
    models = {Order => {invalid: {qty: :abc}}}
    check_models models
  end

  def test_invalids
    models = {
      Order => {
        invalids: [
          {qty: :abc},
          {name: "Name", qty: :def}
        ]
      }
    }
    check_models models
  end

  def test_class_methods
    models = {Order => {class_methods: %i[class_method]}}
    check_models models
  end

  def test_call_class_methods
    models = {Order => {call_class_methods: %i[class_method]}}
    check_models models
  end

  def test_public_methods
    models = {Order => {public_methods: %i[public_method]}}
    check_models models
  end

  def test_call_public_methods
    models = {
      Order => {
        valid: {name: "Name", qty: 123},
        call_public_methods: %i[public_method]
      }
    }
    check_models models
  end

  def test_several
    models = {
      Order => {
        valid: {name: "Name", qty: 123},
        invalid: {qty: :abc},
        class_methods: %i[class_method],
        call_class_methods: %i[class_method],
        public_methods: %i[public_method],
        call_public_methods: %i[public_method]
      }
    }
    check_models models
  end
end
