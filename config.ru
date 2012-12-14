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
  before do
    @ga = ENV['GOOGLE_ANALYTICS_UA']
    @header = ENV['SIGNATURES_HEADER'] || "Signatures"
  end

  get '/' do
    @title = "Signatures, we want yours"
    slim :index
  end

  get '/thanks' do
    @title = "Thanks!"
    slim :thanks
  end

  post '/sign' do
    check_the_pot
    @signature = Signature.new(email: params[:email])
    if @signature.save
      redirect '/thanks'
    else
      @errors = @signature.errors.full_messages
      slim :index
    end
  end

  def check_the_pot
    unless params[:email_address].empty?
      halt 418, "ZOMG HONEY!!!" * 100
    end
  end
end

run RubyDesignSignature.new
