# encoding: UTF-8
#lib/tasks/proc_binomial_names.rake
desc "proc the binomial name list"
task :proc_binomial_names => [:environment] do

  DQ  = "\""
  CR  = "\n"
  

   def get_names
    infile   = File.expand_path('db/dev_data/names/binomial_names.txt')
    input_file = File.new(infile, "r")
    names = input_file.readlines
    input_file.close
    return names
   end

   def label_ttl(binomial, ustring, abbrev)
    pref_label = 'bn:' + ustring  + ' skos:prefLabel ' + DQ + binomial + DQ  + ' .'
    alt_label  = 'bn:' + ustring  + ' skos:altLabel '  + DQ + abbrev   + DQ  + ' .'
    label_ttl = pref_label + CR + alt_label
   end #label_ttl

   def type_ttl(ustring)
    type_ttl = 'bn:' + ustring  + ' rdf:type txn:TaxonNameID .' + CR + 'bn:' + ustring  + ' rdf:type txn:BinomialNameID .'
   end #type_ttl

  def valid_name(binomial)
   if (binomial.match(/[[:ascii:]]/)) && !(binomial.include? "_") && !(binomial.include? "[") && !(binomial.include? "]") && !(binomial.include? "{") && !(binomial.include? "}") && !(binomial.include? ".") && !(binomial.include? ",") then
     return 'true'
   else
     return 'false'
   end
  end

  def valid_binomial_array(name_array)
      if name_array[0].match(/[A-Z][a-z]*/) && name_array[1].match(/[a-z][a-z]*/)  && name_array[1].match(/[[:lower:]]/ ) then
        return 'true'
       else
        return  'false'
      end    
  end

  def create_with_binomial(binomial)
    name_array = binomial.split(" ")
    wordcount = name_array.count
    genus = name_array[0].to_s
    first_char = genus[0] + "."
    epithet = name_array[1].to_s
    e_char  = epithet[0]
    if (wordcount == 2) && (genus.match(/[A-Z][a-z]*/)) && (e_char.match(/[a-z]/)) && (epithet.match(/[a-z]+/)) && (epithet.match(/[[:lower:]]/)) && !(epithet == 'nr') && !(epithet == 'nsp') &&  !(epithet == 'species') then
      abbrev = first_char + " " + epithet
      ustring = binomial.gsub(" ","_")
      size = binomial.length
      b_object = BinomialObject.new(binomial, genus, epithet, abbrev, ustring, size)
    else
      puts binomial + ' is not a valid binomial name'
    end #if
    return b_object
  end

   def name_object_array
     name_list  = get_names
     name_number = name_list.count
     puts name_number.to_s + ' binomial names'
     # name_set = Set.new
     name_object_array = Array.new
     name_list.each do |name|
       binomial = name.chomp!
       binomial.gsub!("\r")
       if !binomial.nil? && (valid_name(binomial) == "true") then
         b_object = create_with_binomial(binomial)
         if !b_object.nil? then 
           name_object_array << b_object
         end #if object not nil
       end #if not nil or invalid
     end #each_do name
     return name_object_array
   end

begin #main
  path     = File.expand_path("tmp/turtle") + "/"
  binomial_io =   File.new(path + 'binomial_names.txt', mode: 'w:UTF-8', cr_newline: false )
  type_io     =   File.new(path + 'binomial_type.ttl',  mode: 'w:UTF-8', cr_newline: false )
  label_io    =   File.new(path + 'binomial_label.ttl', mode: 'w:UTF-8', cr_newline: false )
  genus_io    =   File.new(path + 'genus_list_with_dups.txt',     mode: 'w:UTF-8', cr_newline: false )
  epithet_io  =   File.new(path + 'epithet_list_with_dups.txt.txt',   mode: 'w:UTF-8', cr_newline: false )
  #
  label_io.puts '@prefix bn:   <urn:eol:bn:> .'
  label_io.puts '@prefix skos: <http://www.w3.org/2004/02/skos/core#> .'
  type_io.puts  '@prefix bn:   <urn:eol:bn:> .'
  type_io.puts  '@prefix skos: <http://www.w3.org/2004/02/skos/core#> .'
  type_io.puts  '@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .'
  type_io.puts  '@prefix txn:  <http://lod.taxonconcept.org/ontology/txn.owl#> .'
  #
  bna = name_object_array
  puts "Binomial Set Created"
  bna.each do |bn|
     binomial_io.puts bn.binomial
     type_io.puts     type_ttl(bn.ustring)
     label_io.puts    label_ttl(bn.binomial, bn.ustring, bn.abbrev)
     genus_io.puts    bn.genus
     epithet_io.puts  bn.epithet
  end #each
  binomial_io.close
  epithet_io.close
  genus_io.close
  type_io.close
  label_io.close
end #mail  
  
end #task