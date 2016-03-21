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
    load_adventure
    @choice = Choice.new(event: @event, outcome: Event.new)
  end

  # GET /choices/1/edit
  def edit
    choice
  end


  # POST /choices
  # POST /choices.json
  def create
    @choice = Choice.new(new_choice_params)

    if @choice.save
      redirect_to @choice, notice: 'Choice was successfully created.'
    else
      load_adventure
      render :new
    end
  end


  # PATCH/PUT /choices/1
  # PATCH/PUT /choices/1.json
  def update
    choice.outcome.update(outcome_params)
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
    params.require(:choice).permit(:decision, :event_id)
  end


  def outcome_params
    params[:choice].require(:outcome)
                   .permit(:title, :description, :adventure_id)
  end


  def new_choice_params
    choice_params.merge(outcome: Event.new(outcome_params))
  end


  def load_event
    @event ||= if params[:event_id]
                 Event.find_by_id(params[:event_id])
               else
                 choice.event
               end
  end


  def load_adventure
    @adventure = @event.adventure
  end
end
