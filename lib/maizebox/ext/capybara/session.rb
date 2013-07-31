require 'capybara/session'
require 'maizebox/renderer'

module Capybara
  class Session
    def attention_here
      attentioner.render_here
    end

    def attention_to(element)
      attentioner.render_to(element)
    end

    def attentioner
      @attentioner ||= Maizebox::Renderer.new
    end
  end
end
