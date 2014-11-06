# encoding: utf-8
class ProfileAvatarUploader < Uploader

  version :big do
    process :resize_to_fill => [620, 350]
  end

  version :thumb do
    process :resize_to_fill => [230, 230]
  end

end
