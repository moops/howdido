class User < ActiveResource::Base
  self.site = APP_CONFIG['auth_host']
end