json.extract! todo, :id, :name, :description, :due, :tag, :created_at, :updated_at
json.url todo_url(todo, format: :json)
