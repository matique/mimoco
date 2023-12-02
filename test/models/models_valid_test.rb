require "test_helper"
require "mimoco"

class ModelsTest < Minitest::Test
  def test_valid
    models = {Order => {valid: {name: "Name", qty: 123}}}
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
end
