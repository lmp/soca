require 'haml'

module Soca
  module Plugins
    class Haml < Soca::Plugin

      name 'haml'
      include Soca::BuildHelpers

      def run(options={})
        @options = options

        build_files(build_map) do |source, dest|
          Soca.logger.debug "Running #{source} through Haml."
          File.open(dest, 'w') do |f|
            f << ::Haml::Engine.new(File.read(source)).render
          end
          Soca.logger.debug "Wrote to #{dest}"
        end
      end

      private
      def build_map
        Dir[File.join(haml_from, "**/*.haml")].map do |src|
          basename = File.basename(src, ".haml")
          dir      = File.dirname(src).sub(/^#{haml_from}/, haml_to)
          dest = File.join(dir, basename + ".html")
          [src, dest]
        end
      end

      def haml_from
        @options.has_key?(:from) ? File.join(app_dir, @options[:from]) : File.join(app_dir, 'haml')
      end

      def haml_to
        @options.has_key?(:to) ? File.join(app_dir, @options[:to]) : File.join(app_dir, '')
      end

    end
  end
end
