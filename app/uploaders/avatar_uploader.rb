# encoding: utf-8
class AvatarUploader < Uploader

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
