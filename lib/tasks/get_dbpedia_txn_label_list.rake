# encoding: UTF-8
#lib/tasks/get_dbpedia_txn_label_list.rake
desc "Creates a Turtle file containing the english DBpedia labels for things of type dbpedia:Species. Note TURTLE errors with quoted names."
task :get_dbpedia_txn_label_list => [:environment] do
require File.expand_path("lib/modules/sparql_query")

  DQ  = "\""

begin #main
  file_path = File.expand_path("tmp/turtle/dbpedia_labels.ttl")
  dbpedia_uri_label_file = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  dbpedia_uri_label_file.puts "@prefix rdfs:	<http://www.w3.org/2000/01/rdf-schema#> ."
  uri_label_array = Array.new
  uri_label_object_array = SparqlQuery.list_dbpedia_taxon_labels(uri_label_array)
  uri_label_object_array.each do |uri_label_object|
    dbpedia_uri_label_file.puts "<" + uri_label_object.uri + "> rdfs:label " + DQ + uri_label_object.label + DQ + "@en ."
  end #uri_label_object_array.each
  dbpedia_uri_label_file.close
end #main 
  
end #task
