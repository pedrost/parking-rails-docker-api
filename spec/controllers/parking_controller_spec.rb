RSpec.describe Api::V1::ParkingController, type: :controller do

  describe '[GET] /parking - all parkings', type: :request do

    context 'when it has only 1 parking created' do

      before do
        parking = Parking.create!(plate: 'VVV-0000')
        get '/parking'
      end

      it 'returns all parkings' do
        expect(JSON.parse(response.body).size).to eq(1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

    end

  end

  describe '[GET] /parking/:plate - show parking ', type: :request do

    before do
      @parking = Parking.create!(plate: 'VVV-0000')
      get "/parking/#{@parking.plate}"
    end

    it 'return 1 parking object with id time paid and left' do
      expect(JSON.parse(response.body).keys).to eq(['id', 'time', 'paid', 'left'])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

  end

  describe '[POST] /parking - create parking', type: :request do

    context 'when parking plate is valid' do

      before do
        post '/parking', params: { 
          :plate => 'CCC-0000'
        }
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end

      context 'when parking already exist' do

        before do
          existing_parking = Parking.create!(plate: 'LLL-0000')
          post '/parking', params: { 
            :plate => existing_parking.plate
          }
        end
  
        it 'returns status code 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns plate already taken error' do
          expect(JSON.parse(response.body)["errors"].join()).to eq(
            "#{I18n.t("activerecord.attributes.parking.plate")} #{I18n.t("activerecord.errors.models.parking.attributes.plate.taken") }"
          )
        end

      end

    end

    context 'when parking plate is not valid' do

      before do
        post '/parking', params: { 
          :plate => 'INVALID'
        }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns attributes plate invalid error' do
        expect(JSON.parse(response.body)["errors"].join()).to eq(
          "#{I18n.t("activerecord.attributes.parking.plate")} #{I18n.t("activerecord.errors.models.parking.attributes.plate.invalid") }"
        )
      end

    end
  end

  describe '[PUT] /parking/:plate/pay - pay parking ', type: :request do

    context 'when parking exists' do
      let(:parking_plate) { 'ZZZ-0000' }

      before do
        parking = Parking.create!(plate: parking_plate)
        put "/parking/#{parking.plate}/pay"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'parking paid attribute is now true' do 
        expect(Parking.find_by(plate: parking_plate).paid).to eq(true)
      end

    end
    context 'when parking not exists' do

      before do
        put '/parking/INVALID-PLATE/pay'
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

    end
  end

  describe '[PUT] /parking/:plate/out - left parking ', type: :request do

    context 'when parking exists' do
      let(:parking_plate) { 'ZZZ-0000' }

      context 'and parking is paid' do

        before do
          parking = Parking.create!(plate: parking_plate)
          put "/parking/#{parking.plate}/pay" # Pays parking
          put "/parking/#{parking.plate}/out"
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'parking left attribute is now true' do 
          expect(Parking.find_by(plate: parking_plate).left).to eq(true)
        end

      end

      context 'and parking is not paid yet' do

        before do
          parking = Parking.create!(plate: parking_plate)
          put "/parking/#{parking.plate}/out"
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

      end

    end

    context 'when parking not exists' do

      before do
        put '/parking/INVALID-PLATE/out'
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

    end

  end

end