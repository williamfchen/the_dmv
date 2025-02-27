class FacilityFactory
  attr_reader :facilities

  def initialize
    @facilities = []
  end

  def create_facilities(locations)
    locations.each do |site|
      details = {
        name: format_name(site),
        address: format_address(site),
        phone: format_phone(site)
      }
      @facilities << Facility.new(details)
    end
  end

  def format_name(data)
    if data[:state] == "CO"
      data[:dmv_office]
    elsif data[:state] == "NY"
      "DMV " + data[:office_name].split.map(&:capitalize).join(" ")
    elsif data[:state] == "MO"
      "DMV " + data[:name].split.map(&:capitalize).join(" ")
    end
  end

  def format_address(data)
    if data[:state] == "CO"
      address_parts = [data[:address_li], data[:address__1], data[:city], data[:state], data[:zip]]
      address_parts.compact.join(" ")
    elsif data[:state] == "NY"
      address_parts = [data[:street_address_line_1], data[:street_address_line_2], data[:city], data[:state], data[:zip_code]].compact
      capitalized_string = address_parts.map { |part| part.split.map(&:capitalize) }.join(" ")
      capitalized_string.gsub(/Ny\b/, "NY")
    elsif data[:state] == "MO"
      address_parts = [data[:address1], data[:city], data[:state], data[:zipcode]].compact
      capitalized_string = address_parts.map { |part| part.split.map(&:capitalize) }.join(" ")
      capitalized_string.gsub(/Mo\b/, "MO")
    end
  end

  def format_phone(data)
    if data[:state] == "CO"
      data[:phone]
    elsif data[:state] == "NY"
      if data[:public_phone_number] != nil
      data[:public_phone_number].insert(6, "-").insert(3, ") ").insert(0, "(")
      else
        data[:public_phone_number]  
      end
    elsif data[:state] == "MO"
      data[:phone]
    end
  end
end