class ContentAttachment < ActiveRecord::Base
  mount_uploader :image, AttachmentUploader

  belongs_to :contents
  belongs_to :users
end
