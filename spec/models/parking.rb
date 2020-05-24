
RSpec.describe Parking do
  describe "#time" do
    context "when someone parked at 00:00 of 25/06/1999 and passes 20 minutes" do
      # Arrange
      subject(:parking) { described_class.create(plate: "0000-0000", created_at: Time.new(1999,6,25, 00,00,0, "+03:00") ) }
      
      it "time hould return 20 minutes" do
        # Act - mock current time
        allow(Time).to receive(:now).and_return(Time.new(1999,6,25, 00,20,0, "+03:00"))
        # Assert
        expect(parking.time).to eq("20 #{I18n.t('tz.minutes')}")
      end
    end
  end
end