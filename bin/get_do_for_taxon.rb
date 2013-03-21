#!/usr/bin/env ruby
require File.expand_path("../lib/modules/sparql_query")
# run this from the command line
# ruby get_do_for_taxon.rb 1030204
# Example:
# ruby get_do_for_taxon.rb 1030204
# Author: Peter J. DeVries
# Date: 2013-03-20

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
  # get data_object_uri's
  do_array = SparqlQuery.get_eol_taxon_do(eol_id, Array.new)
  do_array.each do |do_uri|
    puts do_uri
  end #do_array.each
 end #def run

end #Class App

# Create and run the application
app = App.new(ARGV, STDIN)
app.run
