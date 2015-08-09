json.array!(@jobs) do |job|
  json.extract! job, :id, :description, :done, :item_id
  json.url job_url(job, format: :json)
end
