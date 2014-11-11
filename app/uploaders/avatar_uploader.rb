# encoding: utf-8
class AvatarUploader < Uploader

  version :big do
    process :resize_to_fill => [788, 310]
  end

  version :large do
    process :resize_to_fill => [370, 310]
  end

  version :profile do
    process :resize_to_fill => [163, 163]
  end

  version :thumb do
    process :resize_to_fill => [79, 79]
  end

end
