require 'selenium-webdriver'
require 'nokogiri'
profile = Selenium::WebDriver::Chrome::Profile.new
profile['download.prompt_for_download'] = false
profile['download.default_directory'] = "/path/to/dir"
driver = Selenium::WebDriver.for :chrome

car_db_url = "http://db.auto.sohu.com/maint_list.shtml"
driver.get car_db_url
#获取不同品牌
brand_page =  Nokogiri::HTML(driver.page_source)
car_lists = brand_page.css(".carList .name a")
car_lists.each do |c|
  title_str = c['title']
  p c['title']
  p "------------------------------------------"
  car_maint_page_url = "http://db.auto.sohu.com/#{c['href']}"
  driver.get car_maint_page_url
  m_car_maint_page = Nokogiri::HTML(driver.page_source)
  #获取车款
  car_type = m_car_maint_page.at("#comtit strong a:first")
  next unless car_type
  car_type_str = car_type.content
  p car_type.content
  p "------------------------------------------------"
  #获取年限
  year = m_car_maint_page.at("#yearid .sel_tit:first")
  year_str = year["data-year"]
  p year["data-year"]
  p "------------------------------------------------"
  #获取版本
  ver = m_car_maint_page.at("#modelid .sel_tit:first")
  ver_str = ver.content
  p ver.content
  p "------------------------------------------------"

  #获取保养手册
  table = m_car_maint_page.at(".tabel1")
  open("export/#{title_str}-#{car_type_str}-#{year_str}-#{ver_str}.html", 'w:UTF-8') do |f|
    f << '<!DOCTYPE html><html><head><meta charset="utf-8" /></head><body>'
    f.puts table.to_s
    f << "</body></html>"
  end

  #获取所有车款
  all_types = m_car_maint_page.css(".top_list .on_sell a")
  links = m_car_maint_page.css(".top_list a[title]")
  links.each do |l|
    href = l['href'] + "maintenance.html"
    p href
    driver.get(href)
    next_page = Nokogiri::HTML(driver.page_source)
    #获取车款
    car_type = next_page.at("#comtit strong a:first")

    next unless car_type
    car_type_str = car_type.content
    p car_type.content
    p "------------------------------------------------"
    #获取年限
    year = next_page.at("#yearid .sel_tit:first")
    year_str = year["data-year"]
    p year["data-year"]
    p "------------------------------------------------"
    #获取版本
    ver = next_page.at("#modelid .sel_tit:first")
    ver_str = ver.content
    p ver.content
    p "------------------------------------------------"

    #获取保养手册
    table = next_page.at(".tabel1")
    open("export/#{title_str}-#{car_type_str}-#{year_str}-#{ver_str}.html", 'w:UTF-8') do |f|
      f << '<!DOCTYPE html><html><head><meta charset="utf-8" /></head><body>'
      f.puts table.to_s
      f << "</body></html>"
    end
  end
end

