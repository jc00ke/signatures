require 'sinatra/base'
require 'slim'

class RubyDesignSignature < Sinatra::Base
  get '/' do
    slim :index
  end

  post '/sign' do
    puts params[:email]
  end
end

run RubyDesignSignature.new
