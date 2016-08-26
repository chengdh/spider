#coding: utf-8
require 'mechanize'
# Create a new instance of Mechanize and grab our page
mech = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}
#车型大全界面
#db_auto_page = mech.get('http://db.auto.sohu.com')

#品牌
#brand_names = db_auto_page.css(".brand_name")
#车型
# car_names = db_auto_page.css(".car_meta .fl .name")
# car_names.each do |name|
#   p name.content
#   p name['href']
# end
#car = car_names.first
url = "http://db.auto.sohu.com/jinkouaudi/1572/maintenance.html"
m_page = mech.get(url)
m_page.links.each do |l|
  p l
end
#p m_page

#获取车款
car_type = m_page.at("#comtit strong a:first")
p car_type.content
#获取年限
year = m_page.at("#yearid .sel_tit:first")
#p year["data-year"]
#获取版本
ver = m_page.at("#modelid .sel_tit:first")
#p ver.content
#获取所有车款

all_types = m_page.css(".list_con")
p all_types


#获取保养信息
table = m_page.at(".tabel1")
table.css("tr").each do |tr|
  # p tr.to_s
  # p "-----------------------------------"
end
# next_page = mech.click(type_list[2])
# doc = next_page.parser
# p doc.at(".top_tit")
#
#获取单一车型的数据
#搜狐汽车抓取
# page = mech.get('http://db.auto.sohu.com/model_4207/Maintenance.shtml')
#
# # Find all the links on the page that are contained within
# # h1 tags.
# input_distance = page.at("#distance")
# input_distance['value'] = 10000
# p input_distance
#
# start_mth = page.at("#slideDownRegion .default")
# start_mth.content = '2016-01' 
# p start_mth
#
# #submit_link = page.css(".viewBtn")
# next_page = page.at(".viewBtn")
#
# p next_page
# mech.click(next_page)
#
# # Click on one of our post links and store the response
# doc = page.parser # Same as Nokogiri::HTML(page.body)
# #车型
# model = doc.at(".title")
# p "车型:"
# p "------------------------------"
# p model.content
#
# p "公里数:#{input_distance['value']}"
#
# p "新车上路时间:#{start_mth.content}"
# p "保养项目"
# p "-------------------------------"
# mantain_items = doc.css(".packageService")
# p mantain_items

#p doc
