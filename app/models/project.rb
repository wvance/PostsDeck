class Project < ActiveRecord::Base
	belongs_to :user
	mount_uploader :image, AttachmentUploader
	acts_as_list
end
