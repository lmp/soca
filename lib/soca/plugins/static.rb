module Soca
  module Plugins
    class Static < Soca::Plugin

      name 'static'
      include Soca::BuildHelpers

      def run(options={})
        @options = options

        Soca.logger.debug `rsync -v -a #{static_from}/ #{static_to}/`
      end

      private

      def static_from
        File.join(app_dir, @options[:from] || "static")
      end

      def static_to
        File.join(app_dir, @options[:to] || "target")
      end

    end
  end
end
