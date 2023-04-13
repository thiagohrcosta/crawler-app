class LeadGeneratorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @data = args
    raw_data = @data

    generate_data
    parsing_data(raw_data)
    binding.pry

    create_lead
    binding.pry
    Lead.last.destroy
  end

  private

  def parsing_data(raw_data)
    raw_data.each_with_index do |x, i|
      x.children.last.content.split("\n\r").each do |line|
        next if line == nil || line == ""

        if line.include? "phone"
          @formatted_data[:phone] = line.split("name")[0].split("\nphone:").last.strip
        elsif line.include?  "name"
          @formatted_data[:name] = line.split("name:").last.strip.split("</p>")[0].strip
        elsif line.include? "vehicle"
          @formatted_data[:selected_vehicle] = line.split("vehicle:").last.split("</p>")[0].strip
        elsif line.include? "price"
          @formatted_data[:price] = line.split("price:").last.split("</p>")[0].strip.remove("=2E").to_f
        elsif line.include? "year"
          @formatted_data[:year] = line.split("year:").last.split("</p>")[0].strip
        else
          next
        end
      end
    end
  end

  def generate_data
    @formatted_data = {
      name: nil,
      phone: nil,
      message: "Testado",
      selected_vehicle: nil,
      price: nil,
      year: nil,
      link: "http://www.google.com"
    }
  end

  def create_lead
    binding.pry
    @lead = Lead.new
    @lead.name = @formatted_data[:name]
    @lead.phone = @formatted_data[:phone]
    @lead.message = @formatted_data[:message]
    @lead.selected_vehicle = @formatted_data[:selected_vehicle]
    @lead.price = @formatted_data[:price]
    @lead.year = @formatted_data[:year]
    @lead.link = @formatted_data[:link]

    if @lead.save!
      puts "SUCESSO +====================="
      @lead
    else
      binding.pry
      puts "ERROOOOOOOOOOOOOOOOOO"
    end
  end
end
