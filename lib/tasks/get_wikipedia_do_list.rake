# encoding: UTF-8
#lib/tasks/get_wikipedia_do_list.rake
desc "Returns a list of data objects which the subject attribute indicates are from Wikipedia"
task :get_wikipedia_do_list => [:environment] do
require File.expand_path("lib/modules/sparql_query")

DQ = '/"'

begin #main
  file_path = File.expand_path("tmp/tab/wikipedia_do_list.tab")
  do_file = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  do_array = SparqlQuery.list_wikipedia_data_objects
  do_array.each do |do_uri|
    do_file.puts do_uri
  end #do_array.each
  do_file.close
end #main 
  
end #task
