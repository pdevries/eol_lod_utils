# encoding: UTF-8
#lib/tasks/proc_genus_names.rake
desc "proc genus name list"
task :proc_genus_names => [:environment] do

  DQ  = "\""
  CR  = "\n"
  

   def get_names
    infile   = File.expand_path('db/dev_data/names/genus_names.txt')
    input_file = File.new(infile, "r")
    names = input_file.readlines
    input_file.close
    return names
   end

   def label_ttl(genus, abbrev)
    pref_label = 'mn:' + genus  + ' skos:prefLabel ' + DQ + genus + DQ  + ' .'
    alt_label  = 'mn:' + genus  + ' skos:altLabel '  + DQ + abbrev   + DQ  + ' .'
    label_ttl = pref_label + CR + alt_label
   end #label_ttl

   def type_ttl(genus)
    type_ttl = "mn:" + genus  + " rdf:type txn:TaxonNameID ." + CR + "mn:" + genus  + " rdf:type txn:MonomialNameID ." + CR + "mn:" + genus  + " rdf:type txn:GenusNameID ."
   end #type_ttl

  def valid_name(genus)
   if (genus.match(/[[:ascii:]]/)) && !(genus.include? "_") && !(genus.include? "[") && !(genus.include? "]") && !(genus.include? "{") && !(genus.include? "}") && !(genus.include? ".") && !(genus.include? ",") && !(genus.include? " ") then
     return 'true'
   else
     return 'false'
   end
  end

  def valid_genus_array(genus)
      if genus.match(/[A-Z][a-z]*/) then
        return 'true'
       else
        return  'false'
      end    
  end

  def create_with_genus(genus)
    genus.chomp!
    first_char = genus[0] + '.'
    if (genus.match(/[A-Z][a-z]*/)) then
      abbrev = first_char
      size = genus.length
      rank = 'Genus'
      genus_object = MonomialObject.new(genus, abbrev, rank, size) 
    else
      puts genus + ' is not a valid genus name'
    end #if
    return genus_object
  end

   def name_object_array
     name_list  = get_names
     name_number = name_list.count
     puts name_number.to_s + ' genus names'
     # name_set = Set.new
     name_object_array = Array.new
     name_list.each do |name|
       genus = name.chomp!
       genus.gsub!("\r")
       if !genus.nil? && (valid_name(genus) == "true") then
         genus_object = create_with_genus(genus)
         if !genus_object.nil? then 
           name_object_array << genus_object
         end #if object not nil
       end #if not nil or invalid
     end #each_do name
     return name_object_array
   end

begin #main
  path      = File.expand_path('tmp/turtle') + '/'
  genus_io  = File.new(path + 'genus_names_list.txt', mode: 'w:UTF-8', cr_newline: false )
  type_io   = File.new(path + 'genus_type.ttl',  mode: 'w:UTF-8', cr_newline: false )
  label_io  = File.new(path + 'genus_label.ttl', mode: 'w:UTF-8', cr_newline: false )
  #
  label_io.puts '@prefix mn:  <urn:eol:mn:> .'
  label_io.puts '@prefix skos: <http://www.w3.org/2004/02/skos/core#> .'
  type_io.puts  '@prefix mn:  <urn:eol:mn:> .'
  type_io.puts  '@prefix skos: <http://www.w3.org/2004/02/skos/core#> .'
  type_io.puts  '@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .'
  type_io.puts  '@prefix txn: <http://lod.taxonconcept.org/ontology/txn.owl#> .'
  #
  gna = name_object_array
  puts 'Genus Set Created'
  gna.each do |gn|
     genus_io.puts    gn.name
     type_io.puts     type_ttl(gn.name)
     label_io.puts    label_ttl(gn.name, gn.abbrev)
  end #each
  genus_io.close
  type_io.close
  label_io.close
end #mail  
  
end #task