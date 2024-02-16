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

      def self.one_valid(params)
        row, msg = create_model(params)
        @minitest.assert row.valid?, "#{msg} #{row.errors.full_messages}"
      end

      def self.one_invalid(params)
        row, msg = create_model(params)
        @minitest.refute row.valid?, "#{msg} expected to be invalid"
      end

      def self.create_model(params)
        # row = @klass.create(params)
        row = @klass.new(params)
        [row, "#{@klass}: #{params}"]
      end
    end
  end
end
