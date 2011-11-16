module Soca
  module BuildHelpers
    class BuildError < StandardError
      attr_reader :filename, :original_exception

      def initialize(filename, original_exception)
        @filename, @original_exception = filename, original_exception
      end

      def backtrace
        @original_exception.backtrace
      end

      def message
        "In #{@filename}: #{@original_exception}"
      end

      alias to_s message
    end

    # takes an array of file pairs [[src1, dest1], [src2, dest2], ...]
    # loops through them, ensuring target directory exists
    # if destination modified more recently than source, it is assumed up-to-date, build not required.
    def build_files(pairs, &block)
      pairs.each do |src, dest|
        begin
          next if File.exist?(dest) && File.mtime(src) < File.mtime(dest) && File.size(dest) > 5
          FileUtils.mkdir_p(File.dirname(dest))
          yield src, dest
        rescue => e
          raise BuildError.new(src, e)
        end
      end
    end
  end
end
