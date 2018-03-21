class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def create
    @event = Event.create({ data: {
      resource: params['resource'],
      event_type: params['event_type'],
      timestamp: params['timestamp'],
      object: params['object']
    }})

    render json: 'ok', status: :ok
  end
end
