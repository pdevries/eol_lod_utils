# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EolLodUtils::Application.initialize!

  #SPARQL Endpoints - set your default here
  EOL_SPARQL_ENDPOINT      = "http://lod.eol.org/sparql"
  TXN_SPARQL_ENDPOINT      = "http://lsd.taxonconcept.org/sparql"
  DBPEDIA_SPARQL_ENDPOINT  = "http://dbpedia/sparql"
  LOCAL_SPARQL_ENDPOINT    = "http://hal.local:8890/sparql"
  DBPEDIA_SPARQL_ENDPOINT  = "http://dbpedia/sparql"
  DEFAULT_SPARQL_ENDPOINT  = "http://lod.eol.org/sparql"
