json.extract! toy, :id, :name, :description, :url, :image_url, :text, :created_at, :updated_at
json.url toy_url(toy, format: :json)