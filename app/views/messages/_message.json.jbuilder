json.extract! message, :id, :body, :user_id
json.content render(partial: "messages/message", locals: { message: message , current_user: current_user}, formats: [:html])
