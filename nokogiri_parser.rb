require 'nokogiri'
#doc = File.open("example.htm") { |f| Nokogiri::HTML(f) }
doc = File.open("/Volumes/data/work_file/一汽丰田-卡罗拉/丰田 卡罗拉 1.6L 2015年产-40000.html") { |f| Nokogiri::HTML(f) }
input_distance = doc.at("#distance")

start_mth = doc.at("#slideDownRegion .default")

#车型
model = doc.at(".title")
p "车型:#{model.content.strip!}"
p "公里数:#{input_distance['value']}"
p "新车上路时间:#{start_mth.content.strip!}"

mantain_items = doc.css(".packageService")
mantain_items.each do |mi|
  #大类
  cat = mi.at(".name")
  p "-----------------------#{cat.content.strip!}----------------------------------"

  details = mi.css(".pack_tt1")
  details.each_with_index do |d,i|
    p "\##{i + 1}. #{d.content.strip!}"
  end
  products = mi.css(".pack_biaoti")
  products.each_with_index do |p,idx|
    p "\##{idx + 1}. #{p.content.strip!}"
  end
end
