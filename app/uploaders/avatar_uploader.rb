# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/#{model.class.to_s.underscore}/" + [version_name, "#{mounted_as}.jpg"].compact.join('_'))
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :big do
    process :resize_to_fill => [788, 310]
  end

  version :large do
    process :resize_to_fill => [370, 310]
  end

  version :thumb do
    process :resize_to_fill => [237, 237]
  end

  version :mini do
    process :resize_to_fill => [79, 79]
  end

end
