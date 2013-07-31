require 'maizebox/js_loader'
require 'maizebox/capybara'

module Maizebox
  class Renderer
    include Maizebox::Capybara

    FRAME_PADDING = '20' # pixel

    def render_here
      locator = current_locator
      render(locator)
    end

    def render_to(element)
      locator = element_locator(element)
      render(locator)
    end

  private

    ##
    #
    # @param  [Array]  locators
    #
    def render(locators)
      jsloader.run
      script = create_frame_script(locators)
      execute(script)
    end

    def create_frame_script(locators)
      locator = locators.join('.')

      <<-EOS
        var node = $(document).#{locator};
        var node_left   = node.offset().left - #{FRAME_PADDING};
        var node_width  = node.width() + #{FRAME_PADDING}*2;
        var node_top    = node.offset().top - #{FRAME_PADDING};
        var node_height = node.height() + #{FRAME_PADDING}*2;

        var overlay = $('<div></div>');
        overlay.css('position', 'absolute')
               .css('zIndex',   10000)
               .css('left',     node_left)
               .css('top',      node_top)
               .css('width',    node_width)
               .css('height',   node_height).#{frame_style};
        $(document.body).append(overlay);
      EOS
    end

    ##
    #
    #     # => .css('border', '2px solid red').css('background-color', 'rgba(0, 0, 0, 0.2)')
    #
    # @return  [String]  String that call function to apply stylesheet jQuery syntax.
    #
    def frame_style
      {
        'border'           => '2px solid red',
        'background-color' => 'rgba(0, 0, 0, 0.2)',
      }.map { |name, value| "css('#{name}', '#{value}')" }.join('.')
    end

    ##
    #
    #     # Without scope
    #     node = find(:css, '#library')
    #     element_locator(node) # => ["find('#library')"]
    #
    #     # Within scope
    #     within(:xpath, '//*[@id="main"]') do
    #       within(:css, 'div#profile') do
    #         node = find(:xpath, '//p[@id="name"]')
    #         element_locator(node)
    #           # => ["xpath('//*[@id=\"main\"]')", "find('div#profile')", "xpath('//p[@id=\"name\"]')"]
    #       end
    #     end
    #
    # @return [Array] A part of jQuery and jquery-xpath syntax for find +element+
    #
    def element_locator(element)
      current_locator << create_jquery_selector(element)
    end

    ##
    #     # Without scope
    #     current_locator # => []
    #
    #     # Within scope
    #     within(:xpath, '//*[@id="main"]') do
    #       within(:css, 'p#author') do
    #         current_locator # => ["xpath('//*[@id=\"main\"]')", "find('p#author')"]
    #       end
    #
    #       current_locator # => ["xpath('//*[@id=\"main\"]')"]
    #     end
    #
    # @return [Array] A part of jQuery and jquery-xpath syntax for find current scope element.
    #
    def current_locator
      # Skip first element (Capybara::Node::Document)
      scopes = browser.send(:scopes)[1..-1]
      scopes.empty? ? [] : scopes.map { |scope| create_jquery_selector(scope) }
    end

    #
    # @param  [Capybara::Node::Element]  element
    # @return [String]  jQuery and jquery-xpath finder syntax
    #
    def create_jquery_selector(element)
      format   = element.query.selector.format
      locator  = element.query.send(format)
      function = (format == :xpath) ? 'xpath' : 'find'

      "#{function}('" + locator.gsub("'", "\\\\'") + "')"
    end

    def jsloader
      @jsloader ||= JsLoader.new
    end
  end
end
