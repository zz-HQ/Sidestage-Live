# encoding: utf-8
class PictureUploader < Uploader

  version :preview do
    process :resize_to_fit => [620, nil]
  end

  version :medium_rect do
    process :resize_to_fill => [376, 310]
  end

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end