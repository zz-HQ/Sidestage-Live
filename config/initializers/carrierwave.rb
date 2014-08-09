# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|

  if Rails.env.production?
    config.fog_credentials = {
      :provider               => ENV['FOG_PROVIDER'],                      # required
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                 # required
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],             # required
      :region                 => 'eu-west-1'                                # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']                           # required
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}         # optional, defaults to {}
    config.root           = Rails.root.join('tmp')
    config.cache_dir      = "carrierwave"
    config.storage        = :fog
    config.asset_host     = ENV['ASSET_HOST']                               # optional, defaults to nil
    config.fog_public     = true
  else
    config.storage        = :file
  end
  
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
  end
  
end
