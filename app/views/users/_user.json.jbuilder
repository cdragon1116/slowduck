json.extract! user, :id, :username, :email
json.content render(partial: "users/user", locals: { user: user }, formats: [:html])
