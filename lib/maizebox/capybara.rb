require 'capybara'

module Maizebox
  module Capybara
    def evaluate(script)
      browser.evaluate_script(script)
    end

    def execute(script)
      browser.execute_script(script)
    end

    def browser
      @browser ||= ::Capybara.current_session
    end
  end
end
