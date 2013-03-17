# encoding: UTF-8
#lib/tasks/proc_subfamily_names.rake
desc "proc subfamily name list"
task :proc_subfamily_names => [:environment] do

  DQ  = "\""
  CR  = "\n"
  

   def get_names
    infile   = File.expand_path("db/dev_data/names/subfamily_names.txt")
    input_file = File.new(infile, "r")
    names = input_file.readlines
    input_file.close
    return names
   end

   def label_ttl(subfamily, abbrev)
    pref_label = "mn:" + subfamily  + " skos:prefLabel " + DQ + subfamily + DQ  + " ."
    alt_label  = "mn:" + subfamily  + " skos:altLabel "  + DQ + abbrev   + DQ  + " ."
    label_ttl = pref_label + CR + alt_label
   end #label_ttl

   def type_ttl(subfamily)
    type_ttl = "mn:" + subfamily  + " rdf:type txn:TaxonNameID ." + CR + "mn:" + subfamily  + " rdf:type txn:MonomialNameID ." + CR + "mn:" + subfamily  + " rdf:type txn:SubfamilyNameID ."
   end #type_ttl

  def valid_name(subfamily)
   if (subfamily.match(/[[:ascii:]]/)) && !(subfamily.include? "_") && !(subfamily.include? "[") && !(subfamily.include? "]") && !(subfamily.include? "{") && !(subfamily.include? "}") && !(subfamily.include? ".") && !(subfamily.include? ",") && !(subfamily.include? " ") then
     return "true"
   else
     return "false"
   end
  end

  def valid_subfamily_array(subfamily)
      if subfamily.match(/[A-Z][a-z]*/) then
        return "true"
       else
        return  "false"
      end    
  end

  def create_with_subfamily(subfamily)
    subfamily.chomp!
    first_char = subfamily[0] + "."
    if (subfamily.match(/[A-Z][a-z]*/)) then
      abbrev = first_char
      size = subfamily.length
      rank = "family"
      subfamily_object = MonomialObject.new(subfamily, abbrev, rank, size) 
    else
      puts subfamily + " is not a valid subfamily name"
    end #if
    return subfamily_object
  end

   def name_object_array
     name_list  = get_names
     name_number = name_list.count
     puts name_number.to_s + " subfamily names"
     # name_set = Set.new
     name_object_array = Array.new
     name_list.each do |name|
       subfamily = name.chomp!
       subfamily.gsub!("\r")
       if !subfamily.nil? && (valid_name(subfamily) == "true") then
         subfamily_object = create_with_subfamily(subfamily)
         if !subfamily_object.nil? then 
           name_object_array << subfamily_object
         end #if object not nil
       end #if not nil or invalid
     end #each_do name
     return name_object_array
   end

begin #main
  path      = File.expand_path("tmp/turtle") + "/"
  subfamily_io = File.new(path + 'subfamily_names_list.txt', mode: 'w:UTF-8', cr_newline: false )
  type_io   = File.new(path + 'subfamily_type.ttl',  mode: 'w:UTF-8', cr_newline: false )
  label_io  = File.new(path + 'subfamily_label.ttl', mode: 'w:UTF-8', cr_newline: false )
  #
  label_io.puts "@prefix mn:   <urn:eol:mn:> ."
  label_io.puts "@prefix skos: <http://www.w3.org/2004/02/skos/core#> ."
  type_io.puts  "@prefix mn:   <urn:eol:mn:> ."
  type_io.puts  "@prefix skos: <http://www.w3.org/2004/02/skos/core#> ."
  type_io.puts  "@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> ."
  type_io.puts  "@prefix txn:  <http://lod.taxonconcept.org/ontology/txn.owl#> ."
  #
  sfna = name_object_array
  puts "Subfamily Set Created"
  sfna.each do |sfn|
     subfamily_io.puts sfn.name
     type_io.puts      type_ttl(sfn.name)
     label_io.puts     label_ttl(sfn.name, sfn.abbrev)
  end #each
  subfamily_io.close
  type_io.close
  label_io.close
end #mail  
  
end #task