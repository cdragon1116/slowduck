module Conversationable
  extend ActiveSupport::Concern
  included do
    validate :conversation_check
  end

  module ClassMethods
    def conversation_group
      ids = Chatroom.where(room_type: 1).ids
      group = ChatroomUser.where('chatroom_id IN (?)', ids).group_by(&:chatroom_id)
    end

    def conversation_between(users_id)
      Chatroom.conversation_group.map{|k, v| [k, v.map{|u| u.user.id}]}.select{ |k, v| v.sort == users_id.sort}
    end

    def conversation_chatroom(users_id)
      Chatroom.find(conversation_between(users_id)[0][0])
    end
  end

  def conversation?
    room_type == 1
  end

  def conversation_with(current_user)
    users.where('user_id != ? ', current_user.id).first
  end

  def conversation_check
    if room_type == 1
      users_id = self.chatroom_users.map{|cu| cu.user_id}
      if Chatroom.conversation_between(users_id).present?
        errors[:conversation_check] << "conversation exists"
      end
    end
  end
end
