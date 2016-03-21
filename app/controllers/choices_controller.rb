class ChoicesController < ApplicationController
  # GET /choices
  # GET /choices.json
  def index
    @choices = Choice.all
  end

  # GET /choices/1
  # GET /choices/1.json
  def show
    choice
  end

  # GET /choices/new
  def new
    @choice = Choice.new
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
    redirect_to choices_url, notice: 'Choice was successfully destroyed.'
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
end
