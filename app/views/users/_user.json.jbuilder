json.extract! user, :id, :username, :email, :image
json.content render(partial: "users/user", locals: { user: user }, formats: [:html])
