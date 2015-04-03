require 'rss'

class ScanRSS
  class << self
    def find_for_rule rule
      find_episodes(rule.feed.url, /#{rule.regex}/i)
    end

    def find_episodes feed, regex
      filter_valid_episodes(build_episodes(parse(feed, regex)))
    end

    def parse feed, regex
      feed = RSS::Parser.parse(get_xml(feed))
      [].tap do |results|
        feed.items.each do |item|
          unless item.title.scan(regex).empty?
            results << item
          end
        end
      end
    end

    def build_episodes items
      items.map do |item|
        Episode.new(name: item.title, link: item.link)
      end
    end

    def filter_valid_episodes eps
      eps.select do |ep|
        ep.valid?
      end
    end

    private

    def get_xml feed
      open(feed)
    end
  end
end