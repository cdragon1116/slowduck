json.extract! message, :id, :body
json.content render(partial: "messages/message", locals: { message: message }, formats: [:html])
