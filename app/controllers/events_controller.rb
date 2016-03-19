class EventsController < ApplicationController
  before_action :verify_master, except: [:show]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    load_event
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    load_event
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to adventure_event_url(adventure_id, @event),
                  notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    load_event
    if @event.update(event_params)
      redirect_to adventure_event_url(adventure_id, @event),
                  notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    load_event
    @event.destroy
    redirect_to adventure_events_url(adventure_id),
                notice: 'Event was successfully destroyed.'
  end


  private

  def load_event
    @event = Event.find(params[:id])
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
    params[:adventure_id] || event_params[:adventure_id]
  end


  def adventure
    Adventure.find(adventure_id)
  end


  def verify_master
    unless current_user == adventure.master
      render_401
    end
  end


end
