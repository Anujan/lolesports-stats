require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'watir'
require 'selenium'
require 'selenium-webdriver'
require 'json'

page = Nokogiri::HTML(open("http://euw.lolesports.com/season3/split2/matches/1"))
match_links = page.css(".match-url").css('a')
players = {}
browser = Watir::Browser.new :firefox, :profile	 => 'default'
match_links.each do |link| 
	browser.goto link['href']
	match_page = Nokogiri::HTML(browser.html)
	player_stats = match_page.css('tr.stat-row')
	player_stats.each do |player_row|
		name = player_row.css('.summoner').text
		player = players[name]
		if player.nil?
			player = {}
		end
		kda = player_row.css('.kdatmpl').text.split('/')
		player[:kills] = player[:kills].nil? ? kda[0].to_i : player[:kills] + kda[0].to_i
		player[:deaths] = player[:deaths].nil? ? kda[1].to_i : player[:deaths] + kda[1].to_i
		player[:assists] = player[:assists].nil? ? kda[2].to_i : player[:assists] + kda[2].to_i
		cs = player_row.css('.minion_kills').text.to_i
		player[:cs] = player[:cs].nil? ? cs : player[:cs] + cs
		players[name] = player
	end
end	
puts players.to_json