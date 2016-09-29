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
car_lists = brand_page.css(".boxA .carList .name a")
end_index = car_lists.length
car_lists.each do |c|
  title_str = c['title']
  p c['title']
  p "------------------------------------------"
  car_maint_page_url = "http://db.auto.sohu.com/#{c['href']}"
  begin
    driver.get car_maint_page_url
  rescue
  end
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
  begin
    open("export/#{title_str}-#{car_type_str}-#{year_str}-#{ver_str}.html", 'w:UTF-8') do |f|
      f << '<!DOCTYPE html><html><head><meta charset="utf-8" /></head><body>'
      f.puts table.to_s
      f << "</body></html>"
    end
  rescue
  end

  #获取所有车款
  links = m_car_maint_page.css(".top_list a[title]")
  links.each do |l|
    href = l['href'] + "maintenance.html"
    p href
    begin
      driver.get href
      wait = Selenium::WebDriver::Wait.new(:timeout => 15)
      link_href = l['href'][0,l['href'].length - 1]
      p link_href
      wait.until { driver.find_element(:css => "#carType[href='#{link_href}']")}
    rescue
    end
    next_page = Nokogiri::HTML(driver.page_source)
    car_type = next_page.at("#carType")
    next unless car_type
    #获取车款
    #car_type = next_page.at("#comtit strong a")
    #p car_type
    car_type_str = car_type.content
    p car_type.content
    p "------------------------------------------------"
    #获取年限
    year = next_page.at("#yearid .sel_tit")
    next unless year
    year_str = year["data-year"]
    p year_str
    p "------------------------------------------------"
    # #获取版本
    ver = next_page.at("#modelid .sel_tit")
    next unless ver
    ver_str = ver.content
    p ver_str
    p "------------------------------------------------"

    #获取保养手册
    table = next_page.at(".tabel1")
    begin
      # open("export/#{title_str}-#{car_type_str}.html", 'w:UTF-8') do |f|
      open("export/#{title_str}-#{car_type_str}-#{year_str}-#{ver_str}.html", 'w:UTF-8') do |f|
        f << '<!DOCTYPE html><html><head><meta charset="utf-8" /></head><body>'
        f.puts table.to_s
        f << "</body></html>"
      end
    rescue
    end
  end
end

driver.quit
