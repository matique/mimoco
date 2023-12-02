require "minitest"

module Minitest
  module Checks
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
  end
end
