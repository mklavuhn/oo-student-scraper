require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :student
  @@all = []

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))

    students = []

    page.css("div.student-card").each do |student|

      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.children[1].attributes["href"].value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))

    attributes = {}


    social = page.css(".social-icon-container").css("a").collect {|e| e.attributes["href"].value}

    social.detect do |links|

      attributes[:twitter] = links if links.include?("twitter")
      attributes[:linkedin] = links if links.include?("linkedin")
      attributes[:github] = links if links.include?("github")
    end

    attributes[:blog] = social[3] if social[3] != nil
    attributes[:profile_quote] = page.css(".profile-quote")[0].text
    attributes[:bio] = page.css(".description-holder").css('p')[0].text
    attributes

  end
    

end

