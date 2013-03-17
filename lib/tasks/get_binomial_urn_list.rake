# encoding: UTF-8
#lib/tasks/get_binomial_urn_list.rake
desc "Returns a list of binomial urns from the endpoint"
task :get_binomial_urn_list => [:environment] do
require File.expand_path("lib/modules/sparql_query")

begin #main
  file_path = File.expand_path("tmp/tab/binomial_query_list.tab")
  binomial_urn_io  = File.new(file_path, mode: 'w:UTF-8', cr_newline: false )
  binomial_urn_array = SparqlQuery.list_binomial_urns
  binomial_urn_array.each do |binomial_urn|
    binomial_urn_io.puts binomial_urn
  end #do_array.each
  binomial_urn_io.close
end #main 
  
end #task
