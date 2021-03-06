require 'minitest/autorun'
require 'xml'
require 'net/http'

class RedditTest < Minitest::Test
  class RedditRssParser
    class RedditRssDocument
      class Entry
        def initialize(entry_xml)
          @entry_xml = entry_xml
        end

        def title
          return nil unless @entry_xml
          node = @entry_xml.find_first('x:title')
          node.content if node
        end
      end

      def initialize(feed_xml)
        @feed_xml = feed_xml
        @feed_xml.root.namespaces.default_prefix = "x"
      end

      def entries
        @entries ||= @feed_xml.find("/x:feed/x:entry")
      end

      def entries_size
        entries.size
      end

      def [](index)
        Entry.new entries[index]
      end
    end

    def parse(feed_xml)
      XML::Error.set_handler do |error|
        nil
      end

      begin
        xml_document = XML::Parser.string(feed_xml).parse
      rescue XML::Error => e
        default_xml_string = <<-XML
<?xml version="1.0" encoding="UTF-8"?><feed xmlns="http://www.w3.org/2005/Atom"></feed>
        XML
        xml_document = XML::Parser.string(default_xml_string).parse
      end

      RedditRssDocument.new(xml_document)
    end
  end

  class RedditRss
    def initialize(options = {})
      @downloader = options[:downloader]
      @parser = options[:parser]
    end

    def rss
      url = "http://www.reddit.com/.rss"
      feed_xml = @downloader.download(url)
      @parser.parse(feed_xml)
    end
  end

  class RedditRssDownloader
    def download(url)
      Net::HTTP.get(URI(url))
    end
  end

  class FakeRedditRssDownloader
    def download(_)
      <<-XML
<?xml version="1.0" encoding="UTF-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <entry>
            <author>
              <name>/u/iBleeedorange</name>
              <uri>https://www.reddit.com/user/iBleeedorange</uri>
            </author>
            <category term="movies" label="/r/movies"/>
            <content type="html">&lt;table&gt; &lt;tr&gt;&lt;td&gt; &lt;a href=&quot;https://www.reddit.com/r/movies/comments/5hij2r/arnold_schwarzenegger_and_jackie_chan_are_making/&quot;&gt; &lt;img src=&quot;https://a.thumbs.redditmedia.com/gh5mwonP0nFkUfkl4lFmuLGuEYguyAxRnrWMHx4Q1U4.jpg&quot; alt=&quot;Arnold Schwarzenegger and Jackie Chan are making a movie together: Journey to China: The Mystery of Iron Mask&quot; title=&quot;Arnold Schwarzenegger and Jackie Chan are making a movie together: Journey to China: The Mystery of Iron Mask&quot; /&gt; &lt;/a&gt; &lt;/td&gt;&lt;td&gt; &amp;#32; submitted by &amp;#32; &lt;a href=&quot;https://www.reddit.com/user/iBleeedorange&quot;&gt; /u/iBleeedorange &lt;/a&gt; &amp;#32; to &amp;#32; &lt;a href=&quot;https://www.reddit.com/r/movies/&quot;&gt; /r/movies &lt;/a&gt; &lt;br/&gt; &lt;span&gt;&lt;a href=&quot;http://i.imgur.com/DCP06ud.jpg&quot;&gt;[link]&lt;/a&gt;&lt;/span&gt; &amp;#32; &lt;span&gt;&lt;a href=&quot;https://www.reddit.com/r/movies/comments/5hij2r/arnold_schwarzenegger_and_jackie_chan_are_making/&quot;&gt;[comments]&lt;/a&gt;&lt;/span&gt; &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</content>
            <id>t3_5hij2r</id>
            <link href="https://www.reddit.com/r/movies/comments/5hij2r/arnold_schwarzenegger_and_jackie_chan_are_making/" />
            <updated>2016-12-10T04:56:44+00:00</updated>
            <title>Arnold Schwarzenegger and Jackie Chan are making a movie together: Journey to China: The Mystery of Iron Mask</title>
          </entry>
        </feed>
      XML
    end
  end

  class FakeRedditRssNoFeedDownloader
    def download(_)
      <<-XML
<?xml version="1.0" encoding="UTF-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
        </feed>
      XML
    end
  end

  class FakeRedditRssEmptyResponseDownloader
    def download(_)
      " "
    end
  end

  def setup
    @parser = RedditRssParser.new
    @downloader = FakeRedditRssDownloader.new

    @reddit_rss = RedditRss.new(downloader: @downloader, parser: @parser)
    @feed = @reddit_rss.rss
  end

  def test_rss
    assert_equal(1, @feed.entries_size)
  end

  def test_feed_title
    title = "Arnold Schwarzenegger and Jackie Chan are making a movie together: Journey to China: The Mystery of Iron Mask"
    assert_equal(title, @feed[0].title)
  end

  def test_empty_feed
    downloader = FakeRedditRssNoFeedDownloader.new
    reddit_rss = RedditRss.new(downloader: downloader, parser: @parser)
    feed = reddit_rss.rss
    assert_equal(nil, feed[0].title)
  end

  def test_empty_respone
    downloader = FakeRedditRssEmptyResponseDownloader.new
    reddit_rss = RedditRss.new(downloader: downloader, parser: @parser)
    feed = reddit_rss.rss
    assert_equal(0, feed.entries_size)
    assert_equal(nil, feed[0].title)
  end
end
