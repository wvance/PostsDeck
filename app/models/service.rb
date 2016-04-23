class Service < ApplicationRecord
  belongs_to :user
  mount_uploader :image, AttachmentUploader
end
