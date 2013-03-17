# encoding: UTF-8
#lib/tasks/proc_family_names.rake
desc "proc family name list"
task :proc_family_names => [:environment] do

  DQ  = "\""
  CR  = "\n"
  

   def get_names
    infile   = File.expand_path('db/dev_data/names/family_names.txt')
    input_file = File.new(infile, 'r')
    names = input_file.readlines
    input_file.close
    return names
   end

   def label_ttl(family, abbrev)
    pref_label = 'mn:' + family  + ' skos:prefLabel ' + DQ + family + DQ  + ' .'
    alt_label  = 'mn:' + family  + ' skos:altLabel '  + DQ + abbrev   + DQ  + ' .'
    label_ttl = pref_label + CR + alt_label
   end #label_ttl

   def type_ttl(family)
    type_ttl = 'mn:' + family  + ' rdf:type txn:TaxonNameID .' + CR + 'mn:' + family  + ' rdf:type txn:MonomialNameID .' + CR + 'mn:' + family  + ' rdf:type txn:FamilyNameID .'
   end #type_ttl

  def valid_name(family)
   if (family.match(/[[:ascii:]]/)) && !(family.include? "_") && !(family.include? "[") && !(family.include? "]") && !(family.include? "{") && !(family.include? "}") && !(family.include? ".") && !(family.include? ",") && !(family.include? " ") then
     return 'true'
   else
     return 'false'
   end
  end

  def valid_family_array(family)
      if family.match(/[A-Z][a-z]*/) then
        return 'true'
       else
        return  'false'
      end    
  end

  def create_with_family(family)
    family.chomp!
    first_char = family[0] + '.'
    if (family.match(/[A-Z][a-z]*/)) then
      abbrev = first_char
      size = family.length
      rank = 'family'
      family_object = MonomialObject.new(family, abbrev, rank, size) 
    else
      puts family + ' is not a valid family name'
    end #if
    return family_object
  end

   def name_object_array
     name_list  = get_names
     name_number = name_list.count
     puts name_number.to_s + ' family names'
     # name_set = Set.new
     name_object_array = Array.new
     name_list.each do |name|
       family = name.chomp!
       family.gsub!("\r")
       if !family.nil? && (valid_name(family) == 'true') then
         family_object = create_with_family(family)
         if !family_object.nil? then 
           name_object_array << family_object
         end #if object not nil
       end #if not nil or invalid
     end #each_do name
     return name_object_array
   end

begin #main
  path      = File.expand_path('tmp/turtle') + '/'
  family_io = File.new(path + 'family_names_list.txt', mode: 'w:UTF-8', cr_newline: false )
  type_io   = File.new(path + 'family_type.ttl',  mode: 'w:UTF-8', cr_newline: false )
  label_io  = File.new(path + 'family_label.ttl', mode: 'w:UTF-8', cr_newline: false )
  #
  label_io.puts '@prefix mn:   <urn:eol:mn:> .'
  label_io.puts '@prefix skos: <http://www.w3.org/2004/02/skos/core#> .'
  type_io.puts  '@prefix mn:   <urn:eol:mn:> .'
  type_io.puts  '@prefix skos: <http://www.w3.org/2004/02/skos/core#> .'
  type_io.puts  '@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .'
  type_io.puts  '@prefix txn:  <http://lod.taxonconcept.org/ontology/txn.owl#> .'
  #
  fna = name_object_array
  puts 'Family Set Created'
  fna.each do |fn|
     family_io.puts    fn.name
     type_io.puts     type_ttl(fn.name)
     label_io.puts    label_ttl(fn.name, fn.abbrev)
  end #each
  family_io.close
  type_io.close
  label_io.close
end #mail  
  
end #task