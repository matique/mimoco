require "minitest"

module Minitest
  module Checks
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
        cls.delete_if { |x| /.*_associated_records_.*/ =~ x }
        #  validate_associated_records_for_projects]
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

  end
end
