require "minitest"

module Minitest
  module Checks
    class Controllers < Base
      def self.respond_to(methods)
        instance = @klass.new
        methods.each { |method|
          msg = "#{@klass} should respond to #{method}"
          @minitest.assert instance.respond_to?(method), msg
        }
      end

      def self.class_methods(expected)
        meths = delete_methods(:methods)
        check_equal expected, meths
      end

      def self.call_class_methods(methods)
        methods.each { |meth|
          check_no_nil @klass.send(meth), "<#{meth}> should return no nil"
        }
      end

      def self.public_methods(expected)
        cls = @klass.new.public_methods(false).sort
        cls.delete_if { |x| /^_/ =~ x }
        check_equal expected, cls
      end
    end
  end
end
