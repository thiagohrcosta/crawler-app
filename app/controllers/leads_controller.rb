class LeadsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'uri'

  def new
    @lead = Lead.new
  end

  def create
    format_is_valid = params[:lead][:file].headers.include? ".eml"

    if format_is_valid == false
      return redirect_to new_lead_path, notice: "Formato inválido"
    end

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
end
  