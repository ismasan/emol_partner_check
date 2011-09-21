require 'net/http'
require 'uri'

class ElMercurioParnerCheck
  
  URL = URI.parse('http://validasocioexterno.elmercurio.cl/ValidaSocio_Externo.asmx/Alianza_ValidaSocio')
  
  def initialize(account_rut, account_local, account_password)
    @config = {
      :RutAlianza   => account_rut,
      :Local        => account_local,
      :Clave        => account_password
    }
  end
  
  def partner?(user_rut)
    options = @config.dup.update(:RutSocio => user_rut)
    
    q = options.map{|k,v| "#{k}=#{v}"}.join('&')
    res = Net::HTTP.start(URL.host, URL.port) {|http|
      fullpath = "#{URL.path}?#{q}"
      http.get(fullpath)
    }
    res.body.to_s.gsub('&lt;', '<').gsub('&gt;', '>') =~ /<Estado>(.+)<\/Estado>/
    $1.to_i == 1
  end
  
end
