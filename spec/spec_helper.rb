require 'rspec'

root = File.expand_path(File.dirname(__FILE__) + '/..') 
$: << "#{root}/lib"

require 'sinatra/base'
require 'sinatra/sequel'

class MockSinatraApp < Sinatra::Base
  register Sinatra::SequelExtension
end
