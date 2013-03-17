# encoding: UTF-8
#lib/tasks/get_eol_txn_thumbnail_list.rake
desc "Queries configured endpoint creating tab delimited eol_id, thumbnail_url file"
task :get_eol_txn_thumbnail_list => [:environment] do
require File.expand_path("lib/modules/sparql_query")

TAB = '	'

begin #main
  file_path = File.expand_path("tmp/tab/eol_id_thumbnails_list.tab")
  tc_thumb_file = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  tc_thumb_array = Array.new
  tc_thumb_file.puts "id" + TAB + "thumbnail"
  tc_do_array = SparqlQuery.list_taxon_thumbnails(tc_thumb_array)
  tc_thumb_array.each do |tc_thumb|
    tc_thumb_file.puts tc_thumb.subject + TAB + tc_thumb.object
  end #tc_thumb_array.each
  tc_thumb_file.close
end #main 
  
end #task
