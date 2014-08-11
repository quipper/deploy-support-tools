json.array! @apps do |app|
  json.name app
  json.servers Rails.cache.read("app-#{app}")
end
