class VehicleGeneratorJob < ApplicationJob
  require "open-uri"
  require "nokogiri"

  queue_as :default

  def perform(*args)
    @lead = args

    vehicle_info = Nokogiri::HTML(URI.open(@lead.last.link))
    formatted_data

    @raw_data = []
    @vehicle_optionals = []

    create_raw_data(vehicle_info)
    parsing_data
    create_vehicle
    generate_optionals(vehicle_info)
  end

  private

  def create_raw_data(vehicle_info)
    vehicle_info.css("div.sc-hmzhuo").each do |vehicle|
      @raw_data << vehicle.text
    end
  end

  def formatted_data
    @formatted_vehicle = {
      lead_id: @lead[0].id,
      brand: nil,
      model: nil,
      km: nil
    }
  end

  def parsing_data
    @raw_data.each do |data|
      next if data == nil

      if data.include? "Marca"
        @formatted_vehicle[:brand] = data.split("Marca").last.strip
      elsif data.include? "Modelo"
        @formatted_vehicle[:model] = data.split("Modelo").last.strip
      elsif data.include? "Quilometragem"
        @formatted_vehicle[:km] = data.split("Quilometragem").last.strip
      end
    end
  end

  def create_vehicle
    @vehicle = Vehicle.create(
      lead_id: @formatted_vehicle[:lead_id],
      brand: @formatted_vehicle[:brand],
      model: @formatted_vehicle[:model],
      km: @formatted_vehicle[:km]
    )
  end

  def generate_optionals(vehicle_info)
    vehicle_data = []
    vehicle_info.css("div.sc-bwzfXH span").each do |vehicle|
      vehicle_data << vehicle.text
    end

    optionals_index_starts_at = vehicle_data.index("Opcionais") + 1
    optionals_index_ends_at = vehicle_data.index("Localização") - 1

    vehicle_data[optionals_index_starts_at..optionals_index_ends_at].each do |optional|
      @optional = Accessory.create(
        name: optional,
        vehicle_id: @vehicle.id
      )
    end
  end
end
