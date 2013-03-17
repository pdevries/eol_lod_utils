# encoding: UTF-8
#!/usr/bin/env ruby
class BinomialObject
  include Comparable

  attr_accessor :binomial, :genus, :epithet, :abbrev, :ustring, :size

  def initialize(binomial, genus, epithet, abbrev, ustring, size)
      @binomial = binomial
      @genus    = genus
      @epithet  = epithet
      @abbrev   = abbrev
      @ustring  = ustring
      @size     = size
  end

  def inspect
      return {:binomial => @binomial,
              :genus    => @genus,
              :epithet  => @epithet,
              :abbrev   => @abbrev,
              :ustring  => @ustring,
              :size     => @size}
  end

  def to_json
      self.inspect.to_json
  end

  def ==(o2)
   if (self.binomial == o2.binomial) && (self.genus == o2.genus) && (self.epithet == o2.epithet) && (self.abbrev == o2.abbrev) && (self.ustring == o2.ustring) && (self.size == o2.size) then
     return true
   else
     return false
   end    
  end #==

  def <=>(o2)
    if self.binomial.size < o2.binomial.size
      -1
    elsif self.binomial.size > o2.binomial.size
      1
    else
      0
    end
  end

  def valid_binomial_array(name_array)
    if name_array[0].match(/[A-Z][a-z]+/) && name_array[1].match(/[a-z]+/) then
      return true
    else
      return false
    end    
  end
  
 end #class  