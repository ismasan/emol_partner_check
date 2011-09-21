require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'json'

$:.<< File.dirname(__FILE__)

require 'el_mercurio_partner_check'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

class App < Sinatra::Base
  
  set :root, APP_ROOT
  set :public, Proc.new{ File.join(root, 'public') }
  set :views, Proc.new{ File.join(root, 'views') }
  
  configure :development do
    CONFIG = YAML.load_file(File.dirname(__FILE__) + '/config.yml')
  end
  
  configure :production do
    CONFIG = {
      :rut      => ENV['ACCOUNT_RUT'],
      :local    => ENV['ACCOUNT_LOCAL'],
      :password => ENV['ACCOUNT_PASSWORD']
    }
  end
  
  get '/?' do
    erb :index
  end
  
  get '/check.json' do
    content_type :json
    rut = params[:rut].to_s.strip
    data = if rut != ''
      is_partner = checker.partner?(rut)
      {:response => is_partner, :rut => rut}
    else
      {:error => 'Necesitas proveer un RUT'}
    end
    JSON.unparse(data)
  end
  
  helpers do
    
    def checker
      @checker ||= ElMercurioParnerCheck.new(CONFIG[:rut], CONFIG[:local], CONFIG[:password])
    end
    
  end
end