#!/usr/bin/env ruby
path      = File.expand_path("../")
require path + '/lib/modules/sparql_query'
require path + '/lib/dbpedia/spotlight'
require path + '/app/models/spotlight_resource'
require path + '/app/models/taxon_do_text'

# run this from the command line
# ruby annotate_do_text.rb 213726
# Example:
# ruby annotate_do_text.rb 213726
# Author: Peter J. DeVries
# Date: 2013-03-21

class App
  attr_reader :options


  DEFAULT_DBSPOTLIGHT_URI = "http://spotlight.dbpedia.org/rest/"
  LOCAL_DBSPOTLIGHT_URI   = "http://spotlight.local:2222/rest/"
  DQ  = "\""

  TEXT = "Despite its worldwide notoriety, very little is known about the natural ecology and behaviour of this predator. These sharks are usually solitary or occur in pairs, although it is apparently a social animal that can also be found in small aggregations of 10 or more, particularly around a carcass (3) (6). Females are ovoviviparous; the pups hatch from eggs retained within their mother's body, and she then gives birth to live young (10). Great white sharks are particularly slow-growing, late maturing and long-lived, with a small litter size and low reproductive capacity (8). Females do not reproduce until they reach about 4.5 to 5 metres in length, and litter sizes range from two to ten pups (8). The length of gestation is not known but estimated at between 12 and 18 months, and it is likely that these sharks only reproduce every two or three years (8) (11). After birth, there is no maternal care, and despite their large size, survival of young is thought to be low (8).Great whites are at the top of the marine food chain, and these sharks are skilled predators. They feed predominately on fish but will also consume turtles, molluscs, and crustaceans, and are active hunters of small cetaceans such as dolphins and porpoises, and of other marine mammals such as seals and sea lions (12). Using their acute senses of smell, sound location and electroreception, weak and injured prey can be detected from a great distance (7). Efficient swimmers, sharks have a quick turn of speed and will attack rapidly before backing off whilst the prey becomes weakened; they are sometimes seen leaping clear of the water (6). Great whites, unlike most other fish, are able to maintain their body temperature higher than that of the surrounding water using a heat exchange system in their blood vessels (11)."
  
  def initialize(argument, stdin)
    @argument = argument
    @stdin = stdin
  end

  def process_standard_input
      input = @stdin.read
  end

  def valid_json(json)  
    begin  
      JSON.parse(json)  
      return true  
    rescue Exception => e  
      return false  
    end
  end  #valid

 def run
  json_path      = File.expand_path("../tmp/json") + "/"
  turtle_path    = File.expand_path("../tmp/turtle") + "/"
  eol_id = @argument[0].to_i || nil
  spotlight = DBpedia::Spotlight(LOCAL_DBSPOTLIGHT_URI)
  do_text_array = SparqlQuery.get_eol_taxon_do_text(eol_id, Array.new)
  do_text_array.each do |do_text|
    do_uri = do_text.data_object.to_s
    data_object_uuid = do_text.data_object.gsub('http://lod.eol.org/dos/','')
    if !do_text.text.empty? && !do_text.text.nil? then
      entities = spotlight.annotate(do_text.text)
      entities.each do |entity|
       #puts entity.inspect
       #puts
       uri = entity["@URI"]
       support = entity["@support"] || nil
       types = entity["@types"] || nil
       surface_form = entity["@surfaceForm"] || nil
       offset = entity["@offset"] || nil
       similarity_score = entity["@similarityScore"] || nil
       percentage_of_second_rank = entity["@percentageOfSecondRank"] || nil
       do_text_object = SpotlightResource.new(do_text.eol_txn, do_text.data_object, uri, support, types, surface_form, offset, similarity_score, percentage_of_second_rank)
       json_io = File.new(json_path + data_object_uuid + '.json', mode: 'w:UTF-8', cr_newline: false )
       json_object =  do_text_object.to_json
       if valid_json(json_object)
         json_io.puts json_object
       end  
       json_io.close
       eol_txn_turtle = do_text.eol_txn.gsub('http://lod.eol.org/txn/','eol_txn:')
       eol_do_turtle  = do_uri.gsub('http://lod.eol.org/dos/','do:')
       eol_dbpedia_subject = uri.gsub('http://dbpedia.org/resource/','dbpedia:')
       turtle_io = File.new(turtle_path + data_object_uuid + '.ttl', mode: 'w:UTF-8', cr_newline: false )
       turtle_io.puts '@prefix eol:      <http://purl.org/biodiversity/eol/> .'
       turtle_io.puts '@prefix eol_txn:  <http://lod.eol.org/txn/> .'
       turtle_io.puts '@prefix do:       <http://lod.eol.org/dos/> .'
       turtle_io.puts '@prefix dcterms:  <http://purl.org/dc/terms/> .'
       turtle_io.puts '@prefix dbpedia:  <http://dbpedia.org/resource/> .'
       #
       turtle_io.puts eol_do_turtle + ' dcterms:subject ' + eol_dbpedia_subject + ' .'
       #turtle_io.puts eol_do_turtle + ' eol:support ' + support.to_s + ' .'
       #turtle_io.puts eol_do_turtle + ' eol:surfaceForm ' + DQ + surface_form + DQ + ' .'
       #turtle_io.puts eol_do_turtle + ' eol:offset ' + offset.to_s + ' .'
       #turtle_io.puts eol_do_turtle + ' eol:similarityScore ' + similarity_score.to_s + ' .'
       #turtle_io.puts eol_do_turtle + ' eol:percentageOfSecondRank ' + percentage_of_second_rank.to_s + ' .'
       turtle_io.close
      end #entities each
    end #text_array.each
   end  #if !do_text.text.empty?
 end #def run


end #Class App

# Create and run the application
app = App.new(ARGV, STDIN)
app.run
