# encoding: UTF-8
#lib/tasks/get_dbpedia_txn_depictions_thumbs_lists.rake
desc "Queries and endpoint and creates TURTLE files of DBpedia taxon depictions and thumbnails. Turtle files need prefixes added"
task :get_dbpedia_txn_depictions_thumbs_lists => [:environment] do
require File.expand_path("lib/modules/sparql_query")

begin #main
  file_path = File.expand_path("tmp/turtle/dbpedia_depictions.ttl")
  dbpedia_depictions_file = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  taxon_depiction_object_array = SparqlQuery.list_dbpedia_depictions(Array.new)
  taxon_depiction_object_array.each do |taxon_depiction|
    dbpedia_depictions_file.puts "<" + taxon_depiction.subject + "> foaf:depiction <" + taxon_depiction.object + "> ."
  end #taxon_depiction_object_array.each
  dbpedia_depictions_file.close
  #
  file_path = File.expand_path("tmp/turtle/dbpedia_thumbnails.ttl")
  dbpedia_thumbnails_file = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  taxon_thumbnails_object_array = SparqlQuery.list_dbpedia_thumbnails(Array.new)
  taxon_thumbnails_object_array.each do |taxon_thumbnail|
    dbpedia_thumbnails_file.puts "<" + taxon_thumbnail.subject + "> dbpedia-owl:thumbnail <" + taxon_thumbnail.object + "> ."
  end #taxon_depiction_object_array.each
  dbpedia_thumbnails_file.close
  
end #main 
  
end #task
