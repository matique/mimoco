# MiMoCo

[![Gem Version](https://badge.fury.io/rb/mimoco.svg)](http://badge.fury.io/rb/mimoco)
[![GEM Downloads](https://img.shields.io/gem/dt/mimoco?color=168AFE&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/mimoco)
[![rake](https://github.com/matique/mimoco/actions/workflows/rake.yml/badge.svg)](https://github.com/matique/mimoco/actions/workflows/rake.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

Mimoco (MInitest MOdels COntrollers) DRY
your tests by specifying some (trivial) of them via a table.

Mimoco doesn't replace the "assert"s of MiniTest.
It is more a kind of a quick and dirty check.
Still, it has demonstrated to be useful, in particular,
to detect code changes which often went unseen.

## Installation

As usual:
```ruby
# Gemfile
gem "mimoco"
```
and run "bundle install".

## Usage for Models

```ruby
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
```

Furthermore, "valids" and "invalids" accepts an array
of hashes to create models to be checked.

"call_public_methods" requires a "valid" item
to instantiated a model used to applicate the methods.

## Usage for Controllers

```ruby
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
      ArticlesController => ...
    }

    check_controllers controllers
  end
end
```

## Parameter

Rails magic adds a few additional methods to a model or a controller
(e.g. #column_headers).

MiMoCo ignores them, but future versions of Rails may add more.
They can be ignored by:

```ruby
check_models models, ignore_methods: magic_method
...
check_controllers controllers, ignore_methods: %i[magic2 magic3]
```

## Miscellaneous

Copyright (c) 2022-2024 Dittmar Krall (www.matiq.com),
released under the [MIT license](https://opensource.org/licenses/MIT).
