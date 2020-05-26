class Api::V1::ParkingController < Api::ApiController

  before_action :find_parking, only: [:show, :out, :pay]

  def index
    return render json: Parking.all, status: :ok
  end

  def show
    return render json: @parking, serializer: ParkingSerializer, status: :ok
  end

  def create
    parking = Parking.new(parking_params)
    return render_success({ reserve_number: parking.id }) if parking.save
    render_unprocessable_entity_error(parking.errors.full_messages)
  end

  def out
    @parking.left!
    return render_success if @parking.errors.blank?
    return render_unprocessable_entity_error(@parking.errors.full_messages)
  end

  def pay
    render_success if @parking.pay!
  end

  private

  def parking_params
    params.permit(:plate)
  end

  def find_parking
    @parking = Parking.find_by(plate: params[:id])
    return render_not_found_error if @parking.blank?
  end

end
