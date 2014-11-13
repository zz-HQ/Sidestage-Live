# encoding: utf-8
class PictureUploader < Uploader

  version :large do
    process :resize_to_fill => [376, 310]
  end

  version :medium do
    process :resize_to_fill => [203, 167]
  end

end