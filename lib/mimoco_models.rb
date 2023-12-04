require "minitest"

module Minitest
  module Checks
    class Models < Base
      def self.class_methods(expected)
        meths = delete_methods(:methods)
#ic 33, @ignore
#        cls = @klass.methods(false).sort
#ic 331, cls
#        cls2 = @klass.superclass.methods(false).sort
#ic 332, cls2
#        cls = cls - cls2 - @ignore
#        cls.delete_if { |x| /^_/ =~ x }
#        cls.delete_if { |x| /^(after|before|find_by)_/ =~ x }
#        cls -= %i[column_headers attribute_type_decorations
#          attributes_to_define_after_schema_loads
#          default_scope_override defined_enums]
        check_equal expected, meths
      end

      # call class methods; don't check result
      def self.call_class_methods(methods)
        methods.each { |meth|
          check_no_nil @klass.send(meth), "<#{meth}> should return no nil"
        }
      end

      def self.public_methods(expected)
        meths = delete_methods(:methods)
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
