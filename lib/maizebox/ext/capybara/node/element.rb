require 'capybara/node/element'

module Capybara
  module Node
    class Element < Base
      attr_reader :query
    end
  end
end
