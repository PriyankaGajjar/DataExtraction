require "selenium-webdriver"
driver = Selenium::WebDriver.for :firefox
@wait =  Selenium::WebDriver::Wait.new(:timeout => 30)
driver.navigate.to "http://yahoo.com"
flag = 0
File.open('.\input.txt').each do |line|
  if("#{line}".gsub(/\s+/, "") == "YES" || "#{line}".gsub(/\s+/, "") == "NO")
    if("#{line}".gsub(/\s+/, "") == "YES")
      flag = 1
      print flag
    end
  	next
  end
  search = "#{line}".split(" ")
  driver.find_element(:xpath,"//input[contains(@title,'Search') or contains(@name,'p') and contains(@type,'text')]").send_keys("#{search[1]}")
  driver.find_element(:xpath,"//*[contains(@id,'search-submit') or contains(@type,'submit')]").click
  @wait.until{driver.find_element(:css,"#link-1")}
  # get current page number
  for j in 1..search[2].to_i
    pagenumber = driver.find_element(:css,"#pg>strong").text
    i=1
    driver.find_elements(:xpath,"//a[contains(@id,'link') and  contains(@class,'yschttl spt')]").each do |result|
      url = driver.find_element(:xpath,"//a[contains(@id,'link-#{i}')]/../../..").find_element(:css,"span").text
      #print (pagenumber +"\t"+result.text+"\t"+url)
      #print ("\n")
      i=i+1
      filename = "Output_#{search[0]}.txt"
      if (File.exist?(filename)== true)
        f= File.open(filename, 'a')
        f.write(pagenumber +"\t"+"#{i-1}"+"\t"+result.text+"\t"+url)
        f.write("\n")
        f.close
      else
        f = File.open(filename, 'w')
      	f.write(pagenumber +"\t"+"#{i-1}"+"\t"+result.text+"\t"+url)
        f.write("\n")
        f.close
      end
    end
    if("#{flag}" == "1")
      source = driver.page_source.to_s
      file = "#{search[1]}"+"#{pagenumber}.html"
      f1=File.open(file,'w')
      f1.write("#{source}")
      f1.close
    end
    driver.find_element(:css,"#pg-next").click
  end
end
drive.quit
