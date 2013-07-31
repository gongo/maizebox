require 'maizebox'

begin
  require 'capybara/poltergeist'
  Capybara.default_driver = :poltergeist
rescue
  Capybara.default_driver = :selenium
end

Capybara.run_server = false

module Maizebox
  module Example
    class Runner
      include ::Capybara::DSL

      def run
        visit 'http://www.apple.com/jp/'

        within(:css, 'div.text') do
          page.attention_here
          page.attention_to(find(:css, 'img', match: :first))
        end

        within(:css, 'aside') do
          within(:css, 'li.first-child') do
            page.attention_here
          end

          within(:css, 'li.third-child') do
            page.attention_to(find(:css, 'img'))
          end
        end

        page.save_screenshot screenshot_file, :full => true
        puts "Create screenshot '#{screenshot_file}'"
      end

      def screenshot_file
        File.dirname(__FILE__) + '/example.png'
      end
    end
  end
end

Maizebox::Example::Runner.new.run
