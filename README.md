== Eol LOD Utilities

Included are some sample utilities and code for querying the EoL LOD data set.
It has one dependency beyond rails - the sparql-client gem.
You can look at the example queries in the sparql_query module
link:https://github.com/pdevries/eol_lod_utils/lib/modules/sparql_query.rb
as a guide for adding your own queries.

Command Line Programs /bin

link:https://github.com/pdevries/eol_lod_utils/bin/get_taxon_info.rb

Will return thumbnails, images, and text for that taxon.

Use: ruby get_taxon_info.rb 213726

link:https://github.com/pdevries/eol_lod_utils/bin/get_do_for_taxon.rb

Will a list of data objects uri's linked to that taxon

Use: ruby get_do_for_taxon.rb  213726

link:https://github.com/pdevries/eol_lod_utils/bin/annotate_do_text.rb

Runs a SPARQL query to return text data_objects for a given taxon, passed the result to a local instance of DBPedia Spotlight and writes Turtle files from the results.

Use: ruby annotate_do_text.rb  213726

This uses code from link:https://github.com/fumi/dbpedia-spotlight-rb which does not seem to be available via RubyGems


Other example queries are run through rake tasks.

== EoL Queries

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_eol_txn_data_objects_list.rake

Queries and endpoint and returns a tab delimited list of eol_id, data_object_uuid

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_eol_txn_thumbnail_list.rake

Queries configured endpoint creating tab delimited eol_id, thumbnail_url file

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_eol_txn_data_objects_list.rake

Queries and endpoint and returns a tab delimited list of eol_id, data_object_uuid

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_wikipedia_do_list.rake

Returns a list of data objects which the subject attribute indicates are from Wikipedia

== DBpedia Queries

Note DBpedia.org endpoint is limited number of lines, so you might want want to setup your own local instance of that data if you run queries returning thousands of lines.

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_dbpedia_txn_depictions_thumbs_lists.rake

Queries and endpoint and creates TURTLE files of DBpedia taxon depictions and thumbnails.
Turtle files will need prefixes added.

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_dbpedia_txn_depictions_thumbs_lists.rake

Queries and endpoint and creates TURTLE files of DBpedia taxon depictions and thumbnails.
Turtle files will need prefixes added.

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_dbpedia_txn_label_list.rake

Creates a Turtle file containing the english DBpedia labels for things of type dbpedia:Species.
to be complete Turtle files, prefixes will need to be added.
Note: Some Turtle syntax errors occur with names that contain quotes. I will need to add code to escape these.

== Name Utilities

This code create urn-based identifiers for various taxonomic name strings. It only checks for some simple errors in the input name strings.
Also the resulting Turtle files come with the following open world understanding. Just because a name string is a genus name string does not mean it can't also be a subgenus or even order name.
These makes sense as non-resolvable urn's only because the urn's serve as identifiers for a given name string i.e. a particular sequence of characters and capitalizations.
This allows others to make statements about these name strings including what names might be synonyms of other names etc.

Scientific names i.e Genus, Family, Order are universal and don't need a language tag like @en. They should also only consist of ASCII characters.
There are other kinds of names used in publications like "Swartzia species A (Torke 295)" - these serve as "surrogate names" for an often missing Linnaean scientific name.

Under this model the following string has two parts:

scientific name = "Puma concolor"

authority       = "(Linnaeus 1771)"

If you need URI's for fully qualified names like, Puma concolor (Linnaeus 1771), see the GlobalNames.org project link:http://globalnames.org/

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/get_binomial_urn_list.rake

Returns a list of the urn form of the binomial strings in a given endpoint.
The binomial strings might not be valid binomials - that depends on whether or not the data in the endpoint is correct
The actual number of lines returned depends on the maximum cursor setting of the endpoint.
If it is set to 1 million lines you will only get 1 million name urn's returned.

Rake tasks for creating urn-based name identifiers:

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/proc_binomial_names.rake

This read a list of names from a file and produces Turtle files creating the urn name string, type and label
It only does very simple checks on each namestring - make sure to use a clean list

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/proc_genus_names.rake

This read a list of names from a file and produces Turtle files creating the urn name string, type and label
It only does very simple checks on each namestring - make sure to use a clean list

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/proc_subfamily_names.rake

This read a list of names from a file and produces Turtle files creating the urn name string, type and label
It only does very simple checks on each namestring - make sure to use a clean list

link:https://github.com/pdevries/eol_lod_utils/lib/tasks/proc_family_names.rake

This read a list of names from a file and produces Turtle files creating the urn name string, type and label
It only does very simple checks on each namestring - make sure to use a clean list


