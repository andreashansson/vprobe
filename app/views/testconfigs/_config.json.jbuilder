json.extract! config, :id, :name, :version, :created_at, :updated_at
json.url config_url(config, format: :json)