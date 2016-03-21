class ChoicesController < ApplicationController
  before_action :load_event

  # GET /choices
  # GET /choices.json
  def index
    @choices = @event.choices
  end

  # GET /choices/1
  # GET /choices/1.json
  def show
    choice
  end

  # GET /choices/new
  def new
    @adventure = @event.adventure
    @choice = Choice.new(event: @event)
  end

  # GET /choices/1/edit
  def edit
    choice
  end

  # POST /choices
  # POST /choices.json
  def create
    @choice = Choice.new(choice_params)

    if @choice.save
      redirect_to @choice, notice: 'Choice was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /choices/1
  # PATCH/PUT /choices/1.json
  def update
    if choice.update(choice_params)
      redirect_to @choice, notice: 'Choice was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /choices/1
  # DELETE /choices/1.json
  def destroy
    choice.destroy
    redirect_to event_choices_url(@event),
                notice: 'Choice was successfully destroyed.'
  end

  private

  def choice
    @choice ||= Choice.find(params[:id])
  end


  def choice_params
    raw = params.require(:choice).permit(:decision, :event_id, :outcome_id)
    outcome_id = raw.delete(:outcome_id)
    raw[:outcome] = Event.find(outcome_id) if outcome_id
    raw
  end


  def load_event
    @event ||= if params[:event_id]
                 Event.find_by_id(params[:event_id])
               else
                 choice.event
               end
  end
end
