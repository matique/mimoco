# MiMoCo

[model_params[Gem Version](https://badge.fury.io/rb/miau.png)](http://badge.fury.io/rb/mimoco)

Mimoco (MInitest MOdels COntrollers) DRY
your tests by specifying some (trivial) of them via table.

Mimoco doesn't replace the "assert"s of MiniTest.
It is more a kind of a quick and dirty check.
Still, it has demonstrated to be useful, in particular,
to detect code changes which often went unseen.

## Installation

~~~ ruby
# Gemfile
gem "mimoco"
~~~
and run "bundle install".

## Usage for Models

~~~ ruby
require "test_helper"
require "mimoco"

class ModelsTest < Minitest::Test
  def test_some
    models = {
      Order => {
        valid: {name: "Name", qty: 123},
        invalid: {qty: :abc},
        class_methods: %i[class_method],
        call_class_methods: %i[class_method],
        public_methods: %i[public_method],
        call_public_methods: %i[public_method]
      },
      Article => ...
    }

    check_models models
  end
end
~~~

Furthermore, "valids" and "invalids" accepts an array
of hashes to create models to be checked.

"call_public_methods" requires a "valid" item
to instantiated a model used to applicate the methods.
