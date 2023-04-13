class LeadsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'uri'

  def new
    @lead = Lead.new
  end

  def create
    params[:lead]

    file = File.open(params[:lead][:file].path)

    html_file = URI.open(file).read
    html_doc = Nokogiri::HTML.parse(html_file, nil, 'utf-8')

    LeadGeneratorJob.perform_now(html_doc)

    Lead.all.each do |lead|
      if lead.vehicles.count == 0
        VehicleGeneratorJob.perform_now(lead)
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :phone, :message, :selected_vehicle, :price, :year, :link)
  end
end
  