class MovementsController < ApplicationController
  load_and_authorize_resource
  before_action :set_movement, only: %i[ show edit update destroy ]

  # GET /movements or /movements.json
  def index
    @movements = Movement.order(:movement_type).page params[:page]
    @movements = @movements.where(date: params[:date]) unless params[:date].blank?
    @movements = @movements.where(:bill_id => params[:bill_id]) if params[:bill_id]
    @movements = @movements.joins(:bill).where('bill.bill_type' => params[:filter]).all unless params[:filter].blank?
    @movements = @movements.order((params[:by] || "date") + " " + (params[:order] || "asc"))
  end

  # GET /movements/1 or /movements/1.json
  def show
  end

  # GET /movements/new
  def new
    @movement = Movement.new
  end

  # GET /movements/1/edit
  def edit
  end

  # POST /movements or /movements.json
  def create
    @movement = Movement.new(movement_params)
    @bill = Bill.find(@movement.bill_id)
    @movement.user_id = current_user.id


    if @movement.date.nil? || @movement.date > @movement.bill.end_time || @movement.date < @movement.bill.begin_date
      redirect_to movements_path, notice: "El movimiento no se realizo. La fecha es invalida."
    else
      if @movement.movement_type == 'C'
        respond_to do |format|
          if @movement.save
            format.html { redirect_to movement_url(@movement), notice: "Movement was successfully created." }
            format.json { render :show, status: :created, location: @movement }
            @movement.total_amount = @bill.balance + @movement.amount
            @movement.save
            @bill.balance = @bill.balance + @movement.amount
            @bill.save
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @movement.errors, status: :unprocessable_entity }
          end
        end
      elsif @movement.movement_type == 'D'
        if @movement.amount > @movement.bill.balance
          redirect_to movements_path, notice: "El movimiento no se realizo. El monto es mayor que el balance."
        else
          respond_to do |format|
            if @movement.save
              format.html { redirect_to movement_url(@movement), notice: "Movement was successfully created." }
              format.json { render :show, status: :created, location: @movement }
              @movement.total_amount = @bill.balance - @movement.amount
              @movement.save
              @bill.balance = @bill.balance - @movement.amount
              @bill.save
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @movement.errors, status: :unprocessable_entity }
            end
          end
        end
      end
    end
  end

  # PATCH/PUT /movements/1 or /movements/1.json
  def update
    if @movement.movement_type == 'C'
      respond_to do |format|
        if @movement.update(movement_params)
          format.html { redirect_to movement_url(@movement), notice: "Movement was successfully updated." }
          format.json { render :show, status: :ok, location: @movement }
          @bill = Bill.find(@movement.bill_id)
          @bill.balance = @bill.balance - @movement.amount
          @bill.save
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @movement.errors, status: :unprocessable_entity }
        end
      end
    elsif @movement.movement_type == 'D'
      if @movement.amount > @movement.bill.balance
        redirect_to movements_path, notice: "El movimiento no se realizo. El monto es mayor que el balance."
      else
        respond_to do |format|
          if @movement.update(movement_params)
            format.html { redirect_to movement_url(@movement), notice: "Movement was successfully updated." }
            format.json { render :show, status: :ok, location: @movement }
            @bill = Bill.find(@movement.bill_id)
            @bill.balance = @bill.balance - @movement.amount
            @bill.save
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @movement.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # DELETE /movements/1 or /movements/1.json
  def destroy
    @movement.destroy
    if @movement.movement_type == 'C'
      if @movement.amount > @movement.bill.balance
        redirect_to movements_path, notice: "El movimiento no se realizo. El monto es mayor que el balance."
      else
        respond_to do |format|
          format.html { redirect_to movements_url, notice: "Movement was successfully destroyed." }
          format.json { head :no_content }
          @bill = Bill.find(@movement.bill_id)
          @bill.balance = @bill.balance - @movement.amount
          @bill.save
        end
      end
    elsif @movement.movement_type == 'D'
      respond_to do |format|
        format.html { redirect_to movements_url, notice: "Movement was successfully destroyed." }
        format.json { head :no_content }
        @bill = Bill.find(@movement.bill_id)
        @bill.balance = @bill.balance + @movement.amount
        @bill.save
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement
      @movement = Movement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movement_params
      params.require(:movement).permit(:movement_type, :date, :time, :amount, :description, :bill_id, :user_id, :total_amount)
    end
end
