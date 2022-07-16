require "rails/generators/base"

module Health
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a Health initializer and sets up files and directories in your project."

      def setup_health_checks_dir
        directory "app/health_checks"
      end
    end
  end
end