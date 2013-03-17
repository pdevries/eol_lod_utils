== Eol LOD Utilities

Included are some sample utilities and code for querying the EoL LOD data set.
It has one dependency beyond rails - the sparql-client gem.
You can look at the example queries in the sparql_query module link:files/lib/modules/sparql_query.rb
as a guide for adding your own queries.

Set your preferred SPARQL endpoint in link:files/config/environment.rb. 

There is a command line application that will return information based on a Eol taxon id.
link:files/bin/get_taxon_info.rb

Example use ruby get_taxon_info.rb 213726
Will return thumbnails, images, and text for that taxon.

Other queries are run through rake tasks.

EoL Queries
link:files/lib/tasks/get_eol_txn_data_objects_list.rake
Queries and endpoint and returns a tab delimited list of eol_id, data_object_uuid

link:files/lib/tasks/get_eol_txn_thumbnail_list.rake
Queries configured endpoint creating tab delimited eol_id, thumbnail_url file

link:files/lib/tasks/get_eol_txn_data_objects_list.rake
Queries and endpoint and returns a tab delimited list of eol_id, data_object_uuid

link:files/lib/tasks/get_wikipedia_do_list.rake
Returns a list of data objects which the subject attribute indicates are from Wikipedia

DBpedia Queries - the DBpedia.org endpoint is configured to not return more than 1000 results.
So you might want want to setup your own local instance of that data.

link:files/lib/tasks/get_dbpedia_txn_depictions_thumbs_lists.rake
Queries and endpoint and creates TURTLE files of DBpedia taxon depictions and thumbnails.
Turtle files will need prefixes added.

link:files/lib/tasks/get_dbpedia_txn_depictions_thumbs_lists.rake
Queries and endpoint and creates TURTLE files of DBpedia taxon depictions and thumbnails.
Turtle files will need prefixes added.

link:files/lib/tasks/get_dbpedia_txn_label_list.rake
Creates a Turtle file containing the english DBpedia labels for things of type dbpedia:Species.
to be complete Turtle files, prefixes will need to be added.
Note: Some Turtle syntax errors occur with names that contain quotes. I will need to add code to escape these.
