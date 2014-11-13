# encoding: utf-8
class PictureUploader < Uploader

  version :preview do
    process :resize_to_fit => [800, nil]
  end

  version :large do
    process :resize_to_fill => [376, 310]
  end

  version :medium_preview do
    process :resize_to_fill => [203, 167]
  end

  version :medium_rect do
    process :resize_to_fill => [300, 300]
  end
  # die Version wird nicht gebraucht, aber um kein Error in partial: '_picture' zu bekommen

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

end