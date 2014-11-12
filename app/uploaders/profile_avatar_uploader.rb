# encoding: utf-8
class ProfileAvatarUploader < Uploader

  version :big do
    process :resize_to_fill => [1295, 370]
  end

  version :preview do
    process :resize_to_fill => [740, 211]
  end

end
