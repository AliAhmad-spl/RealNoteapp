json.extract! note, :id, :title, :description, :start, :end, :event, :members, :user_id, :created_at, :updated_at
json.url note_url(note, format: :json)
