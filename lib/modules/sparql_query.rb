# encoding: UTF-8
#!/usr/bin/env ruby
#lib/modules/sparql_query.rb
$LOAD_PATH << './lib'
require 'sparql/client'

#This module is used to run some standard SPARQL Queries
module SparqlQuery

  TAB = "\t"

  ##TODO This needs more error checking
  def SparqlQuery.valid_dbpedia_uri(dbpedia_uri)
    if dbpedia_uri.start_with?("http://dbpedia.org/resource/") then
      return true
    else
      return false
    end #if    
  end #SparqlQuery.valid_dbpedia_uri(dbpedia_uri)

### Get Info about a DBpedia URI

  def SparqlQuery.get_dbpedia_binomial_name_array(dbpedia_uri)
    if valid_dbpedia_uri(dbpedia_uri) then
      binomial_name_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      subject = "<" + dbpedia_uri + ">"
      result = sparql.query("SELECT DISTINCT ?o WHERE {#{subject} <http://dbpedia.org/property/binomial> ?o }")
      result.each do |line|
          object   = line[:o].to_s
          binomial_name_array << object
      end #do each line
      return binomial_name_array
     else
       return binomial_name_array << "Not a valid dbpedia URI"
     end #if  
   end #SparqlQuery.get_dbpedia_binomial_name_array(dbpedia_uri)

  def SparqlQuery.get_dbpedia_label_array(dbpedia_uri)
    if valid_dbpedia_uri(dbpedia_uri) then
      label_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      subject = "<" + dbpedia_uri + ">"
      result = sparql.query("SELECT DISTINCT ?o WHERE {#{subject} <http://www.w3.org/2000/01/rdf-schema#label> ?o }")
      result.each do |line|
          object   = line[:o].to_s
          label_array << object
      end #do each line
      return label_array
     else
       return label_array << "Not a valid dbpedia URI"
     end #if  
   end #SparqlQuery.get_dbpedia_label_array(dbpedia_uri)

  def SparqlQuery.get_dbpedia_redirects(dbpedia_uri)
    if valid_dbpedia_uri(dbpedia_uri) then
      redirects_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      subject = "<" + dbpedia_uri + ">"
      result = sparql.query("SELECT DISTINCT ?o WHERE {#{subject} <http://dbpedia.org/ontology/wikiPageRedirects> ?o }")
      result.each do |line|
          object   = line[:o].to_s
          redirects_array << object
      end #do each line
     return redirects_array
    else
       return redirects_array << "Not a valid dbpedia URI"
    end #if  
   end #SparqlQuery.get_dbpedia_redirects(dbpedia_uri)

# Get Lists from DBpedia Data

  def SparqlQuery.list_dbpedia_depictions(depiction_array)
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s ?o WHERE {?s <http://xmlns.com/foaf/0.1/depiction> ?o. ?s <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://dbpedia.org/ontology/Species> }")
      result.each do |line|
          subject  = line[:s].to_s
          object   = line[:o].to_s
          depiction_object = SubjectObject.new(subject,object)
          depiction_array << depiction_object
      end #do each line
      return depiction_array
   end #SparqlQuery.list_dbpedia_depictions(depiction_array)

  def SparqlQuery.list_dbpedia_thumbnails(thumbnail_array)
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s ?o WHERE {?s <http://dbpedia.org/ontology/thumbnail> ?o. ?s <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://dbpedia.org/ontology/Species> }")
      result.each do |line|
          subject  = line[:s].to_s
          object   = line[:o].to_s
          thumbnail_object = SubjectObject.new(subject,object)
          thumbnail_array << thumbnail_object
      end #do each line
      return thumbnail_array
   end #SparqlQuery.list_dbpedia_thumbnails(thumbnail_array)

  def SparqlQuery.list_dbpedia_taxa_uris
      dbpedia_taxon_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s a <http://dbpedia.org/ontology/Species>}")
      result.each do |line|
          subject   = line[:s].to_s
          dbpedia_taxon_array << subject
      end #do each line
      return dbpedia_taxon_array
   end #SparqlQuery.list_dbpedia_taxa_uris

  def SparqlQuery.list_dbpedia_taxon_labels(uri_label_array)
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s ?o WHERE {?s <http://www.w3.org/2000/01/rdf-schema#label> ?o. ?s a <http://dbpedia.org/ontology/Species>. FILTER ( lang(?o) = 'en' )}")
      result.each do |line|
          uri   = line[:s].to_s
          label = line[:o].to_s
          uri_label_array << UriLabelObject.new(uri,label)
      end #do each line
      return uri_label_array
   end #SparqlQuery.list_dbpedia_taxon_labels(uri_label_array)

### Get Lists of things

  def SparqlQuery.list_taxa
      tc_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s ?p <http://purl.org/biodiversity/eol/Taxon>}")
      result.each do |line|
          subject = line[:s].to_s
          subject.gsub!("http://lod.eol.org/txn/","")
          tc_array << subject
      end #do each line
      return tc_array
   end #SparqlQuery.list_taxa

  def SparqlQuery.list_data_objects
      do_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?o WHERE {?s <http://purl.org/biodiversity/eol/hasDataObject> ?o }")
      result.each do |line|
          object   = line[:o].to_s
          do_array << object
      end #do each line
      return do_array
   end #SparqlQuery.list_data_objects

  def SparqlQuery.list_tc_data_objects(tc_do_array)
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s ?o WHERE {?s <http://purl.org/biodiversity/eol/hasDataObject> ?o }")
      result.each do |line|
          subject  = line[:s].to_s
          subject.gsub!("http://lod.eol.org/txn/","")
          object   = line[:o].to_s
          object.gsub!("http://lod.eol.org/dos/","")
          tc_do_object = SubjectObject.new(subject,object)
          tc_do_array << tc_do_object
      end #do each line
      return tc_do_array
   end #SparqlQuery.list_tc_data_objects(tc_do_array)

  def SparqlQuery.list_text_data_objects
      do_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s ?p <http://purl.org/biodiversity/eol/TextObject>}")
      result.each do |line|
          subject   = line[:s].to_s
          do_array << subject
      end #do each line
      return do_array
   end #SparqlQuery.list_text_data_objects

  def SparqlQuery.list_image_data_objects
      do_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s ?p <http://purl.org/biodiversity/eol/ImageObject>}")
      result.each do |line|
          subject   = line[:s].to_s
          do_array << subject
      end #do each line
      return do_array
   end #SparqlQuery.list_image_data_objects

  def SparqlQuery.list_video_data_objects
      do_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s ?p <http://purl.org/biodiversity/eol/VideoObject>}")
      result.each do |line|
          subject   = line[:s].to_s
          do_array << subject
      end #do each line
      return do_array
   end #SparqlQuery.list_video_data_objects

  def SparqlQuery.list_taxon_thumbnails(tc_thumb_array)
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s ?o WHERE {?s <http://lod.taxonconcept.org/ontology/txn.owl#thumbnail> ?o. ?s <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/biodiversity/eol/Taxon> }")
      result.each do |line|
          subject  = line[:s].to_s
          subject.gsub!("http://lod.eol.org/txn/","")
          object   = line[:o].to_s
          tc_thumb_object = SubjectObject.new(subject,object)
          tc_thumb_array << tc_thumb_object
      end #do each line
      return tc_thumb_array
   end #SparqlQuery.list_taxon_thumbnails(tc_thumb_array)

  def SparqlQuery.list_taxon_depictions(tc_depiction_array)
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s ?o WHERE {?s <http://xmlns.com/foaf/0.1/depiction> ?o. ?s <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/biodiversity/eol/Taxon> }")
      result.each do |line|
          subject  = line[:s].to_s
          subject.gsub!("http://lod.eol.org/txn/","")
          object   = line[:o].to_s
          tc_depiction_object = SubjectObject.new(subject,object)
          tc_depiction_array << tc_depiction_object
      end #do each line
      return tc_depiction_array
   end #SparqlQuery.list_taxon_depictions(tc_depiction_array)

  def SparqlQuery.list_wikipedia_data_objects
      do_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      predicate = '<http://purl.org/dc/terms/subject>'
      object    = '<http://www.eol.org/voc/table_of_contents#Wikipedia>'
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s #{predicate} #{object}}")
      result.each do |line|
          subject   = line[:s].to_s
          do_array << subject
      end #do each line
      return do_array
   end #SparqlQuery.list_wikipedia_data_objects

  def SparqlQuery.list_binomial_urns
      binomial_name_array = Array.new
      sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
      result = sparql.query("SELECT DISTINCT ?s WHERE {?s a <http://lod.taxonconcept.org/ontology/txn.owl#BinomialNameID>}")
      result.each do |line|
          subject   = line[:s].to_s
          binomial_name_array << subject
      end #do each line
      return binomial_name_array
   end #SparqlQuery.list_binomial_urns

## Get information about a specific taxon id

  def SparqlQuery.get_eol_taxon_thumbnails(eol_id, image_url_array)
     if !eol_id.nil? && eol_id.kind_of?(Integer) then
        taxon_uri = "<http://lod.eol.org/txn/" + eol_id.to_s + ">"
        sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
        result = sparql.query("select distinct ?thumb where {#{taxon_uri} a <http://purl.org/biodiversity/eol/Taxon>. #{taxon_uri} <http://lod.taxonconcept.org/ontology/txn.owl#thumbnail> ?thumb}")
        result.each do |line|
            image_url   = line[:thumb].to_s
            image_url_array << image_url
        end #do each line
      else
        image_url_array = nil
      end    
      return image_url_array
   end #SparqlQuery.get_eol_taxon_thumbnails(eol_id image_url_array)

  def SparqlQuery.get_eol_taxon_depictions(eol_id, image_url_array)
     if !eol_id.nil? && eol_id.kind_of?(Integer) then
        taxon_uri = "<http://lod.eol.org/txn/" + eol_id.to_s + ">"
        sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
        result = sparql.query("select distinct ?depiction where {#{taxon_uri} a <http://purl.org/biodiversity/eol/Taxon>. #{taxon_uri} <http://xmlns.com/foaf/0.1/depiction> ?depiction}")
        result.each do |line|
            image_url   = line[:depiction].to_s
            image_url_array << image_url
        end #do each line
      else
        image_url_array = nil
      end    
      return image_url_array
  end #SparqlQuery.get_eol_taxon_thumbnails(eol_id image_url_array)

  def SparqlQuery.get_eol_taxon_text(eol_id, text_array)
     if !eol_id.nil? && eol_id.kind_of?(Integer) then
        taxon_uri = "<http://lod.eol.org/txn/" + eol_id.to_s + ">"
        sparql = SPARQL::Client.new(DEFAULT_SPARQL_ENDPOINT)
        result = sparql.query("select distinct ?text where {#{taxon_uri} <http://purl.org/biodiversity/eol/hasDataObject> ?do. ?do a <http://purl.org/biodiversity/eol/TextObject>. ?do <http://purl.org/biodiversity/eol/resultText> ?text}")
        result.each do |result_text|
            do_text   = result_text[:text].to_s
            text_array << do_text
        end #do each line
      else
        text_array = nil
      end    
      return text_array
  end #SparqlQuery.get_eol_taxon_text(eol_id, text_array)

end #module
