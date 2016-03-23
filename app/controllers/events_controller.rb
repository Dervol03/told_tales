class EventsController < ApplicationController
  before_action :load_adventure
  before_action :verify_master, except: [:show]

  # GET /events
  # GET /events.json
  def index
    load_events
  end


  # GET /events/1
  # GET /events/1.json
  def show
    event
  end


  # GET /events/new
  def new
    @event = Event.new(adventure: @adventure)
    load_unfollowed_events
  end


  # GET /events/1/edit
  def edit
    event
    load_unfollowed_events
  end


  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to adventure_events_url(adventure_id),
                  notice: 'Event was successfully created.'
    else
      render :new
    end
  end


  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if event.update(event_params)
      redirect_to adventure_events_url(@adventure),
                  notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end


  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    msg = if event.destroy
            'Event was successfully destroyed.'
          else
            event.errors[:base].join(' ')
          end

    redirect_to adventure_events_url(@adventure), notice: msg
  end


  # Sets the Event ready
  def ready
    event.update(ready: true)
    load_events
    render :index
  end


  private

  def load_events
    @events = @adventure.events
  end


  def event
    @event ||= Event.find(params[:id])
  end


  def event_params
    params.require(:event).permit(
      :title,
      :description,
      :previous_event_id,
      :adventure_id
    )
  end


  def adventure_id
    params[:adventure_id]
  end


  def load_adventure
    id = adventure_id
    @adventure ||= if id
                     Adventure.find(adventure_id)
                   else
                     event.adventure
                   end
  end


  def load_unfollowed_events
    @unfollowed_events = @adventure.unfollowed_events.reject do |event|
      event.id == params[:id].to_i
    end
  end


  def verify_master
    render_401 unless current_user == @adventure.master
  end
end
