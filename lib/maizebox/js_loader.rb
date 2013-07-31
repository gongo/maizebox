require 'maizebox/capybara'

module Maizebox
  class JsLoader
    class JsLoaderError < StandardError ; end

    include Maizebox::Capybara

    JS_DIR = File.dirname(__FILE__) + '/../js'

    def run
      jquery_load unless jquery_loaded?
      jquery_xpath_load unless jquery_xpath_loaded?
    rescue => e
      p e
      raise e
    end

  private

    def jquery_loaded?
      evaluate '(typeof jQuery !== "undefined")'
    end

    def jquery_xpath_loaded?
      evaluate '(typeof jQuery.xpath !== "undefined")'
    end

    def jquery_load
      execute jquery_string
    end

    def jquery_xpath_load
      execute jquery_xpath_string
    end

    def jquery_string
      read 'jquery-1.10.2'
    end

    def jquery_xpath_string
      read 'jquery.xpath'
    end

    def read(package)
      File.read(JS_DIR + "/#{package}.min.js")
    end
  end
end
