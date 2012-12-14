require 'sinatra/base'
require 'slim'
require 'sequel'

DB = Sequel.connect('sqlite://signatures.db')

DB.create_table(:signatures) do
  primary_key :id
  String :email
end unless DB.tables.include?(:signatures)

class Signature < Sequel::Model
  plugin :validation_helpers
  def raise_on_save_failure
    false
  end

  def validate
    super
    validates_presence [:email]
    validates_unique :email
  end
end

class RubyDesignSignature < Sinatra::Base
  get '/' do
    slim :index
  end

  get '/thanks' do
    slim :thanks
  end

  post '/sign' do
    halt 418, "ZOMG HONEY!!!" * 100 if params[:email_address]
    @signature = Signature.new(email: params[:email])
    if @signature.save
      redirect '/thanks'
    else
      @errors = @signature.errors.full_messages
      slim :index
    end
  end
end

run RubyDesignSignature.new
