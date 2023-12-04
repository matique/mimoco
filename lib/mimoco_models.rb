require "minitest"

module Minitest
  module Checks
    class Models < Base
      def self.class_methods(expected)
        meths = delete_methods(:methods)
        check_equal expected, meths
      end

      # call class methods; don't check result
      def self.call_class_methods(methods)
        methods.each { |meth|
          check_no_nil @klass.send(meth), "<#{meth}> should return no nil"
        }
      end

      def self.public_methods(expected)
        meths = delete_methods(:public_instance_methods)
        check_equal expected, meths
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
    end
  end
end
