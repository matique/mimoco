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
      attr_accessor :minitest, :klass, :klass_hash, :where

      def self.run(data, minitest)
        @minitest = minitest
        data.each do |klass, hash|
          @klass = klass
          @klass_hash = hash
          hash.each do |function, value|
            @where = "#{klass}##{function}"
            send(function, value)
          end
        end
      end

      def self.check_equal(expected, actual, msg = nil)
        expected = expected.sort.map(&:to_sym)
        actual = actual.sort.map(&:to_sym)
        msg = msg ? "#{@where}: #{msg}" : @where
        @minitest.assert_equal expected, actual, msg
      end

      def self.check_no_nil(actual, msg = nil)
        msg = msg ? "#{@where}: #{msg}" : @where
        @minitest.refute_nil actual, msg
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

      def self.class_methods(expected)
        cls = @klass.methods(false).sort
        cls.delete_if { |x| /^_/ =~ x }
        cls.delete_if { |x| /^(after|before|find_by)_/ =~ x }
        cls -= %i[column_headers attribute_type_decorations
          attributes_to_define_after_schema_loads
          default_scope_override defined_enums]
        check_equal expected, cls
      end

      # call class methods; don't check result
      def self.call_class_methods(methods)
        methods.each { |meth|
          check_no_nil @klass.send(meth), "<#{meth}> should return no nil"
        }
      end

      def self.public_methods(expected)
        cls = @klass.public_instance_methods(false).sort
        cls -= %i[autosave_associated_records_for_projects
          validate_associated_records_for_projects]
        check_equal expected, cls
      end

      # call_public_methods; don't check result
      def self.call_public_methods(methods)
        klass_params = @klass_hash[:valid] || @klass_hash[:valids]&.first
        raise ValidMissingError unless klass_params

        methods.each { |meth|
          row, _msg = @klass.create(klass_params)
          check_no_nil row.send(meth), "<#{meth}> should return no nil"
        }
      end

      def self.one_valid(params)
        row, msg = create_model(params)
        @minitest.assert row.valid?, "#{msg} #{row.errors.full_messages}"
      end

      def self.one_invalid(params)
        row, msg = create_model(params)
        @minitest.refute row.valid?, "#{msg} expected to be invalid"
      end

      def self.create_model(params)
        row = @klass.create(params)
        [row, "#{@klass}: #{params}"]
      end
    end

    class Controllers < Base
      def self.respond_to(methods)
        instance = @klass.new
        methods.each { |method|
          msg = "#{@klass} should respond to #{method}"
          @minitest.assert instance.respond_to?(method), msg
        }
      end

      def self.class_methods(expected)
        cls = @klass.methods(false).sort
        cls.delete_if { |x| /^_/ =~ x }
        cls -= %i[__callbacks helpers_path middleware_stack]
        check_equal expected, cls
      end

      def self.call_class_methods(methods)
        methods.each { |meth|
          check_no_nil @klass.send(meth), "<#{meth}> should return no nil"
        }
      end

      def self.public_methods(expected)
        cls = @klass.new.public_methods(false).sort
        check_equal expected, cls
      end
    end
  end

  class Test
    include Checks
  end
end
