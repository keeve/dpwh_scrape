require 'nokogiri'
require 'open-uri'
require 'csv'


def grabPage(url_part)
	html_data = open("http://www.dpwh.gov.ph/doing_business/procurement/civil_works/reg_contractors.asp?cat=#{url_part}").read
	nokogiri_object = Nokogiri::HTML(html_data)
	contractors = nokogiri_object.xpath("//table[@id='AutoNumber21']//td//font")
	
	arr_contractors = contractors.to_a
	
	return arr_contractors
end

def addRowToCSV(csv,contractors)
	contractor_name = ""
	contractors.each_with_index do |contractor , index|			
		if  (index + 1) % 2 == 0
			csv << [contractor_name, contractor.text.strip]
		end
		contractor_name = contractor.text.strip
	end	
	return csv
end


CSV.open("c:\\contractors.csv", "w") do |csv|

	#get list of contractors with names starting with numbers
	arr_contractors = grabPage "num"
	#delete last record as it is not needed
	arr_contractors.delete_at(arr_contractors.count - 1)
	
	#add to csv 
	addRowToCSV csv,arr_contractors
	
	#loop from a to z (contractors sorted by letter)
	("a".."z").each { |letter|
		arr_contractors = grabPage letter
		
		#delete the 1st header 
		arr_contractors.delete_at(0)
		#delete the 2st header
		arr_contractors.delete_at(0)
		#delete the last record as it is not needed
		arr_contractors.delete_at(arr_contractors.count - 1)
		
		#add to csv 
		addRowToCSV csv,arr_contractors	
	}
end


	


