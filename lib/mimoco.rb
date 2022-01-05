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
      attr_accessor :minitest, :klass, :klass_hash

      def self.run(data, minitest)
        @minitest = minitest
        data.each do |klass, hash|
          @klass = klass
          @klass_hash = hash
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
        cls = @klass.methods(false).sort
        cls.delete_if { |x| /^_/ =~ x }
        cls.delete_if { |x| /^(after|before|find_by)_/ =~ x }
        cls -= %i[column_headers attribute_type_decorations
          attributes_to_define_after_schema_loads
          default_scope_override defined_enums]
        names = "[#{methods.sort.join(" ")}]"
        msg = "#{@klass.name} must have class_methods #{names}"
        @minitest.assert_equal methods.sort.map(&:to_sym), cls, msg
      end

      # call class methods; don't check result
      def self.call_class_methods(methods)
        methods.each { |method|
          msg = "#{msg} #{method} should return no nil"
          @minitest.refute_nil @klass.send(method), msg
        }
      end

      def self.public_methods(methods)
        cls = @klass.public_instance_methods(false).sort
        cls -= %i[autosave_associated_records_for_projects
          validate_associated_records_for_projects]
        names = "[#{methods.sort.join(" ")}]"
        msg = "#{@klass.name} must have public_methods #{names}"
        @minitest.assert_equal methods.sort.map(&:to_sym), cls, msg
      end

      # call_public_methods; don't check result
      def self.call_public_methods(methods)
        klass_params = @klass_hash[:valid] || @klass_hash[:valids]&.first
        raise ValidMissingError unless klass_params

        methods.each { |method|
          row, msg = @klass.create(klass_params)
          msg = "#{msg} #{method} should return no nil"
          @minitest.refute_nil row.send(method), msg
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
      # check response
      def self.respond_to(methods)
        instance = @klass.new
        methods.each { |method|
          msg = "#{@klass} should respond to #{method}"
          @minitest.assert instance.respond_to?(method), msg
        }
      end

      # controller should have some class methods
      def self.class_methods(expected)
        class_methods = @klass.methods(false).sort
        class_methods -= %i[__callbacks helpers_path middleware_stack]
        @minitest.assert_equal expected, class_methods
      end

      # call class methods; result should be no nil
      def self.call_class_methods(methods)
        methods.each { |method|
          msg = "#{msg} #{method} should return no nil"
          @minitest.refute_nil @klass.send(method), msg
        }
      end

      # controller should ONLY respond to public methods
      def self.public_methods(expected)
        pub = @klass.new.public_methods(false).sort
        @minitest.assert_equal expected, pub
      end
    end
  end

  class Test
    include Checks
  end
end
