class LeadsController < ApplicationController
  require "open-uri"
  require "nokogiri"

  def new
    @lead = Lead.new
  end

  def create
    #@lead = Lead.new(lead_params)
    params[:lead]

    file = File.open(params[:lead][:file].path)
    #document = Nokogiri::XML(file)

    ## need to ensure utf8 encoding
    #document.encoding = 'utf-8'

    html_file = URI.open(file).read
    html_doc = Nokogiri::HTML.parse(html_file, nil, 'utf-8')

    LeadGeneratorJob.perform_now(html_doc)
    binding.pry

  
    # a = params[:lead][:file].read
    
    # raw_data = []

    # a.split("\r\n").each do |line|
    #   raw_data << line.split("\t")
    # end

    # raw_data = raw_data[36...44].flatten.join.split("<p>").split("</p>")
    # raw_data = raw_data.flatten
    # binding.pry 

    # formatted_data = {
    #   name: nil,
    #   phone: nil,
    #   message: nil,
    #   selected_vehicle: nil,
    #   price: nil,
    #   year: nil,
    #   link: nil
    # }

    # name = raw_data.each_with_index do |x, i|
    #   next if x == nil

    #   if x.include? "phone"
    #     formatted_data[:phone] =  x.split("phone:").last.split("</p>")[0].strip
    #   elsif x.include?  "name"
    #     formatted_data[:name] = x.split("name:").last.strip.split("</p>")[0].strip
    #   elsif x.include? "vehicle"
    #     formatted_data[:selected_vehicle] = x.split("vehicle:").last.split("</p>")[0].strip
    #   elsif x.include? "price"
    #     formatted_data[:price] = x.split("price:").last.split("</p>")[0].strip
    #   elsif x.include? "year"
    #     formatted_data[:year] = x.split("year:").last.split("</p>")[0].strip
    #   elsif x.include? "link"
    #     formatted_data[:link] = x.split("link:").last.split("</p>")[0].strip
    #   else
    #     formatted_data[:message] = raw_data[-2].split("</p>")[0].strip
    #   end
    # end

    # puts formatted_data    
    binding.pry
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :phone, :message, :selected_vehicle, :price, :year, :link)
  end
end
  