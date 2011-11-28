require 'coffee-script'

module Soca
  module Plugins
    class CoffeeScript < Soca::Plugin
      include Soca::BuildHelpers

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

        build_files(build_map) do |src, dest|
          bare = true
          cs_opts = {}

          Soca.logger.debug "Running #{src} through CoffeeScript."
          vars[:config]["guardedCoffeeScriptDirectories"].each do |bare_dir|
            dir = File.join(app_dir, "target", bare_dir)
            re = /#{Regexp.escape(dir)}/
            bare = false if re === dest
            cs_opts = vars.merge(:bare => bare)
          end
          File.open(dest, 'w') do |f|
            f << ::CoffeeScript.compile(File.read(src), cs_opts)
          end
          Soca.logger.debug "Wrote #{bare ? "(bare) " : ""}to #{dest}"
        end
      end

      private
      def build_map
        Dir[File.join(coffeescript_from, "**/*.coffee")].map do |src|
          basename = File.basename(src, ".coffee")
          dir      = File.dirname(src).sub(/^#{coffeescript_from}/, coffeescript_to)
          dest = File.join(dir, basename + ".js")
          [src, dest]
        end
      end

      def coffeescript_from
        @options.has_key?(:from) ? File.join(app_dir, @options[:from]) : File.join(app_dir, 'coffee')
      end

      def coffeescript_to
        @options.has_key?(:to) ? File.join(app_dir, @options[:to]) : app_dir
      end

    end
  end
end
