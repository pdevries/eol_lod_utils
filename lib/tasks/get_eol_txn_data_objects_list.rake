# encoding: UTF-8
#lib/tasks/get_eol_txn_data_objects_list.rake
desc "Queries and endpoint and returns a tab delimited list of eol_id, data_object_uuid"
task :get_eol_txn_data_objects_list => [:environment] do
require File.expand_path("lib/modules/sparql_query")

DQ = '/"'
TAB = '	'

begin #main
  file_path = File.expand_path("tmp/tab/taxon_data_object_query_list.tab")
  tc_do_file = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  tc_do_array = Array.new
  tc_do_file.puts "id" + TAB + "data_object_uuid"
  tc_do_array = SparqlQuery.list_tc_data_objects(tc_do_array)
  tc_do_array.each do |tc_do|
    tc_do_file.puts tc_do.subject + TAB + tc_do.object
  end #tc_do_array.each
  tc_do_file.close
end #main 
  
end #task
