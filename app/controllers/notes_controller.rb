require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"
class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  CALENDAR_ID = 'primary'
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
 def create
    client = get_google_calendar_client current_user
    note = params[:note]
    event = get_event note
    client.insert_event('primary', event)
    flash[:notice] = 'Note was successfully added.'
    redirect_to notes_path
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def get_google_calendar_client current_user
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless (current_user.present? && current_user.access_token.present? && current_user.refresh_token.present?)
    secrets = Google::APIClient::ClientSecrets.new({
      "web" => {
        "access_token" => current_user.access_token,
        "refresh_token" => current_user.refresh_token,
        "client_id" => ENV["GOOGLE_API_KEY"],
        "client_secret" => ENV["GOOGLE_API_SECRET"]
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "refresh_token"

      if !current_user.present?
        client.authorization.refresh!
        current_user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      end
    rescue => e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to :back
    end
    client
  end
  
  private
 
  def get_event note
    attendees = note[:members].split(',').map{ |t| {email: t.strip} }
            byebug
    event = Google::Apis::CalendarV3::Event.new({
      summary: note[:title],
      location: '800 St., Gulshan Ravi, Lahore 54000',
      description: note[:description],
      attendees: attendees,
           start: {
        date_time: DateTime.now,
        time_zone: "Asia/Kolkata"
        # date_time: '2019-09-07T09:00:00-07:00',
        # time_zone: 'Asia/Kolkata',
      },
      end: {
        date_time: DateTime.now + 1.hour,
        time_zone: "Asia/Kolkata"
      },
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
        ]
      },
      notification_settings: {
        notifications: [
                        {type: 'event_creation', method: 'email'},
                        {type: 'event_change', method: 'email'},
                        {type: 'event_cancellation', method: 'email'},
                        {type: 'event_response', method: 'email'}
                       ]
      }, 'primary': true
    })
  end
end

