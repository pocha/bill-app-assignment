json.array!(@users) do |user|
  json.extract! user, :id, :is_employee, :is_affiliate, :registered_on, :name
  json.url user_url(user, format: :json)
end
