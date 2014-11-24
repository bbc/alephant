#!/usr/bin/env ruby

$: << File.expand_path(File.join(File.dirname(__FILE__), '..'))

require "env"
require "app"

App.run!
