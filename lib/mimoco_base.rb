require "minitest"

module Minitest
  module Checks
    class Base
      attr_accessor :minitest, :klass, :klass_hash, :where

      def self.run(data, minitest, ignore_methods)
        @minitest = minitest
        @ignore = [ignore_methods].flatten
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

      def self.delete_methods(which)
        ignore2 = %i[attribute_aliases
          attributes_to_define_after_schema_loads column_headers
          default_scope_override]
        # cls -= %i[__callbacks helpers_path middleware_stack]
        # cls -= %i[attribute_type_decorations defined_enums]
        methods = @klass.send(which, false).sort
        methods.delete_if { |x| /^_/ =~ x }
        methods.delete_if { |x| /^(after|before|find_by)_/ =~ x }
        methods.delete_if { |x| /.*_associated_records_.*/ =~ x }
        methods.delete_if { |x| /.*_association_names/ =~ x }
        methods2 = @klass.superclass.send(which, false).sort
        methods - methods2 - @ignore - ignore2
      end
    end
  end
end
