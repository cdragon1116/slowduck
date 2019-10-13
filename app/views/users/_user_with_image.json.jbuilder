json.extract! user, :id, :username, :email
json.image render(partial: "users/user_image", locals: { user: user }, formats: [:html])
