require 'coffee-script'

module Soca
  module Plugins
    class CoffeeScript < Soca::Plugin

      name 'coffeescript'

      # Run the coffeescript plugin.
      # Available options:
      #
      # * :files - Run these files through CoffeeScript. Can be an array of patterns
      #            or a single file. The default is '*.coffee'.
      # * :vars - Additional variables to interpolate. By default the `env` and
      #             `config` are interpolated.
      #
      def run(options = {})
        @options = options

        vars = {
          :env => pusher.env,
          :config => pusher.config
        }.merge(options[:vars] || {})
        Soca.logger.debug "CoffeeScript vars: #{vars.inspect}"

        Dir[File.join(coffeescript_from, "**/*.coffee")].each do |file|
          Soca.logger.debug "Running #{file} through CoffeeScript."
          basename = File.basename(file, ".coffee")
          dir      = File.dirname(file).sub(/^#{coffeescript_from}/,
                                            coffeescript_to)
          new_file = basename + ".js"

          File.open(File.join(dir, new_file), 'w') do |f|
            f << ::CoffeeScript.compile(File.read(file), vars)
          end
          Soca.logger.debug "Wrote to #{File.join(dir, new_file)}"
        end
      end

      private
      def coffeescript_from
        @options.has_key?(:from) ? File.join(app_dir, @options[:from]) : File.join(app_dir, 'coffee')
      end

      def coffeescript_to
        @options.has_key?(:to) ? File.join(app_dir, @options[:to]) : File.join(app_dir, 'js')
      end

    end
  end
end
