class ContentAttachment < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :contents
  belongs_to :users
end
