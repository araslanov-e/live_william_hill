# encoding: utf-8
require "rubygems"
require "mechanize"

agent = Mechanize.new
agent.pluggable_parser.default = Mechanize::Page # перебирать XML как Page

LINK = "http://pricefeeds.williamhill.com/bet/en-gb?action=GoPriceFeed"

agent.get(LINK) do |page|

  # строки таблицы
  page.search("tr").each do |tr|
    break if tr.search("td[colspan='3']").text =~ %r{NON-LIVE} # только LIVE
    next if tr.search("td[colspan='3']").text =~ %r{LIVE} # заголовок
    next if tr.search("th").length.nonzero? # название столбцов

    # XMLs (как Page)
    agent.get(tr.search("a").attr("href")) do |xml|
      # puts xml.search("class").attr("name") # спорт

      # лиги
      xml.search("type").each do |league|
        # puts league.attr("name") # лига

        # исходы (bets)
        league.search("market").each do |market|
          # массив значения атрибута, название команд и название ставки
          #TODO неправильно при: Hapoel Gilboa Galil v KK Mornar - 3rd Quarter - Last Team To Score Live
          market_name, home_team, away_team, bet_name = market.attr("name").match(/(.+)\sv\s(.+)\s-\s(.+)/).to_a
          puts "#{home_team} : #{away_team}"

        end
      end

    end

    break # пока разбираюсь с одним файлом

  end

end