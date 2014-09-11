# This file is copied to spec/ when you run 'rails generate rspec:install'
#require File.expand_path("../../config/environment", __FILE__)
require_relative "../lib/visual_studio_files.rb"
#require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(File.absolute_path(__FILE__)),"support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

class SampleFiles
  def self.folder
    File.join(File.dirname(__FILE__), 'sample_files')
  end
  
  def self.project_csproj
    File.open(File.join(folder, 'project.csproj'),"r").read
  end

  def self.isop_csproj
    File.open(File.join(folder, 'Isop.csproj'),"r").read
  end

  def self.isop_cli_csproj
    File.open(File.join(folder, 'Isop.Cli.csproj'),"r").read
  end

  def self.none_csproj
    File.open(File.join(folder, 'none.csproj'),"r").read
  end

  def self.content_csproj
    File.open(File.join(folder, 'content.csproj'),"r").read
  end
end