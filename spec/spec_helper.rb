require 'rspec'
require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

Coveralls.wear!

root = File.expand_path(File.dirname(__FILE__) + '/..') 
$: << "#{root}/lib"

require 'sinatra/base'
require 'sinatra/sequel'

class MockSinatraApp < Sinatra::Base
  register Sinatra::SequelExtension
end
