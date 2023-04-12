class LeadsController < ApplicationController
  require "open-uri"
  require "nokogiri"

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    params[:lead]
    file = File.open(params[:lead][:file].path)
    document = Nokogiri::XML(file)

    html_file = URI.open(file).read
    html_doc = Nokogiri::HTML.parse(html_file)

    a = params[:lead][:file].read
    a.split("\r\n").each do |line|
      puts line
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :phone, :message, :selected_vehicle, :price, :year, :link)
  end
end
  