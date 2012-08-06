$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'logger'
require 'json/pure'
require 'ext/string'
require 'ext/filemethods'
require 'tres/app'
require 'tres/packager'
require 'tres/template_renderer'
require 'tres/errors'

module Tres
  class << self
    def quiet!
      @quiet = true
    end
    
    def quiet?
      !!@quiet
    end
    
    def verbose!
      @quiet = false
    end
    
    def say something
      STDOUT.puts something unless quiet?
      yield if block_given?
    end

    def error message
      STDERR.puts message unless quiet?
    end

    def root
      @root ||= File.expand_path File.dirname(__FILE__)/'..'
    end

    def templates_path
      root/'templates'
    end

    def styles_path
      root/'sass'
    end

    def scripts_path
      root/'coffee'
    end
  end
  VERSION = File.read Tres.root/'VERSION'
end
