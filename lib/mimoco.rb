require "minitest"

module Minitest
  module Checks
    def check_models(data)
      Models.run data, self
    end

    def check_controllers(data)
      Controllers.run data, self
    end

    class ValidMissingError < StandardError; end

    class Base
      attr_accessor :minitest, :model, :model_hash

      def self.run(data, minitest)
        @minitest = minitest
        data.each do |model, hash|
          @model = model
          @model_hash = hash
          hash.each do |key, value|
            send(key, value)
          end
        end
      end
    end

    class Models < Base
      def self.valid(params)
        valids([params])
      end

      def self.valids(arr)
        arr.each { |params| one_valid(params) }
      end

      def self.invalid(params)
        invalids([params])
      end

      def self.invalids(arr)
        arr.each { |params| one_invalid(params) }
      end

      def self.class_methods(methods)
        cls = @model.methods(false).sort
        cls.delete_if { |x| /^_/ =~ x }
        cls.delete_if { |x| /^(after|before|find_by)_/ =~ x }
        cls -= %i[column_headers attribute_type_decorations
          attributes_to_define_after_schema_loads
          default_scope_override defined_enums]
        names = "[#{methods.sort.join(" ")}]"
        msg = "#{@model.name} must have class_methods #{names}"
        @minitest.assert_equal methods.sort.map(&:to_sym), cls, msg
      end

      # call class methods; don't check result
      def self.call_class_methods(methods)
        methods.each { |method|
          msg = "#{msg} #{method} should return no nil"
          @minitest.refute_nil @model.send(method), msg
        }
      end

      def self.public_methods(methods)
        cls = @model.public_instance_methods(false).sort
        cls -= %i[autosave_associated_records_for_projects
          validate_associated_records_for_projects]
        names = "[#{methods.sort.join(" ")}]"
        msg = "#{@model.name} must have public_methods #{names}"
        @minitest.assert_equal methods.sort.map(&:to_sym), cls, msg
      end

      # call_public_methods; don't check result
      def self.call_public_methods(methods)
        model_params = @model_hash[:valid] || @model_hash[:valids]&.first
        raise ValidMissingError unless model_params

        methods.each { |method|
          row, msg = @model.create(model_params)
          msg = "#{msg} #{method} should return no nil"
          @minitest.refute_nil row.send(method), msg
        }
      end

      private

      def self.one_valid(params)
        row, msg = create_model(params)
        @minitest.assert row.valid?, "#{msg} #{row.errors.full_messages}"
      end

      def self.one_invalid(params)
        row, msg = create_model(params)
        @minitest.refute row.valid?, "#{msg} expected to be invalid"
      end

      def self.create_model(params)
        row = @model.create(params)
        [row, "#{@model}: #{params}"]
      end
    end

    class Controllers < Base
def self.public_methods(params)
p 777
ic params
end
    end
  end

  class Test
    include Checks
  end
end


=begin
require "minitest"

module Minitest

...
    def class_methods(model, methods, _model_params)
      cls = model.methods(false).sort
      cls.delete_if { |x| /^_/ =~ x }
      cls.delete_if { |x| /^(after|before|find_by)_/ =~ x }
      cls -= %i[column_headers attribute_type_decorations
        attributes_to_define_after_schema_loads
        default_scope_override defined_enums]
      names = "[#{methods.sort.join(" ")}]"
      msg = "#{model.name} must have class_methods #{names}"
      assert_equal methods.sort.map(&:to_sym), cls, msg
    end

    # call class methods; don't check result
    def call_class_methods(model, methods, _params)
      methods.each { |method|
        msg = "#{msg} #{method} should return no nil"
        refute_nil model.send(method), msg
      }
    end

    def public_methods(model, methods, _model_params)
      cls = model.public_instance_methods(false).sort
      cls -= %i[autosave_associated_records_for_projects
        validate_associated_records_for_projects]
      names = "[#{methods.sort.join(" ")}]"
      msg = "#{model.name} must have public_methods #{names}"
      assert_equal methods.sort.map(&:to_sym), cls, msg
    end

    # call_public_methods; don't check result
    def call_public_methods(model, methods, model_params)
      methods.each { |method|
        row, msg = model.create(model_params)
        msg = "#{msg} #{method} should return no nil"
        refute_nil row.send(method), msg
      }
    end

...
  end

...
end
=end
