require "httparty"
require "nokogiri"


URL = "https://www.ceneo.pl/Meble"
response = HTTParty.get(URL)


if response.code == 200
    puts "Successful response"
    puts "==========="
else
    puts "Error in response: #{response.code}"
end

document = Nokogiri::HTML4(response.body)

examined_products = document.css("div.cat-prod-row")
print "Product name : price\n"

examined_products.each do |element|
    title =  element["data-productname"]
    price =  element["data-price"]
    print "#{title} : #{price} zł\n"

end



