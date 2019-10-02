class Tag < ApplicationRecord
  has_many :messages , through: :message_tag
  has_many :message_tags

  validates :tagname, presence: true, uniqueness: { allow_blank: false, case_sensitive: true }
end
