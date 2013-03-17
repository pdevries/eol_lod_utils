#!/usr/bin/env ruby
require File.expand_path("../lib/modules/sparql_query")
# run this from the command line
# ruby get_taxon_info.rb 1030204
# Example:
# ruby get_taxon_info.rb 1030204
# Author: Peter J. DeVries
# Date: 2013-03-17

class App
  attr_reader :options

  def initialize(argument, stdin)
    @argument = argument
    @stdin = stdin

  end

  def process_standard_input
      input = @stdin.read
  end

 def run
  eol_id = @argument[0].to_i || nil
  # get thumbnails
  thumbnail_array = SparqlQuery.get_eol_taxon_thumbnails(eol_id, Array.new)
  thumbnail_array.each do |thumbnail|
    puts thumbnail
  end #thumbnail_array.each
  # get depictions
  depiction_array = SparqlQuery.get_eol_taxon_depictions(eol_id, Array.new)
  depiction_array.each do |depiction|
    puts depiction
  end #depiction.each
  # get resultText  
  text_array = SparqlQuery.get_eol_taxon_text(eol_id, Array.new)
  text_array.each do |result_text|
    puts result_text.to_s
  end #text_array.each
 end #def run

end #Class App

# Create and run the application
app = App.new(ARGV, STDIN)
app.run
