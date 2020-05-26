
RSpec.describe Parking do
  describe "#time" do
    context "when someone parked at 00:00 of 25/06/1999 and passes 20 minutes" do
      # Arrange
      subject(:parking) { described_class.create(plate: "AAA-0000", created_at: Time.new(1999,6,25, 00,00,0, "+03:00") ) }
      
      it "time should return 20 minutes" do
        # Act - mock current time to pretend passed 20 minutes
        allow(Time).to receive(:now).and_return(Time.new(1999,6,25, 00,20,0, "+03:00"))
        # Assert
        expect(parking.time).to eq("20 #{I18n.t('tz.minutes')}")
      end
    end
  end

  describe "#pay!" do
    context "when someone pays a parking" do
      # Arrange
      subject(:parking) { described_class.create(plate: "AAA-0000") }
      
      it "pays parking" do
        # Act
        parking.pay!
        # Assert
        expect(parking.paid).to eq(true)
      end
    end
  end

  describe "#left!" do
    context "when someone lefts a parking" do

      context "when payed parking before left" do
        # Arrange
        subject(:parking) { described_class.create(plate: "AAA-0000") }
        
        it "left the parking" do
          # Act - Pays parking before left
          parking.pay!
          parking.left!
          # Assert
          expect(parking.left).to eq(true)
        end
      end

      context "when not payed parking before left" do
        subject(:parking) { described_class.create(plate: "AAA-0000") }

        it "tries left parking and return an error" do
          # Act - Doesent pays parking before left
          # Assert
          expect(parking.left!).to eq([
            I18n.t("activerecord.errors.models.parking.attributes.left.not_paid")
          ])
          expect(parking.left).to eq(false)
        end
      end
    end
  end
end