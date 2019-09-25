class MessageTag < ApplicationRecord
  belongs_to :tag
  belongs_to :message
end
