# encoding: UTF-8
#!/usr/bin/env ruby

class MonomialObject
  include Comparable

  attr_accessor :name, :abbrev, :rank, :size

  def initialize( name, abbrev, rank, size)
      @name     = name
      @abbrev   = abbrev
      @rank     = rank
      @size     = size
  end

  def inspect
      return {
              :name     => @name,
              :abbrev   => @abbrev,
              :rank     => @rank,
              :size     => @size}
  end

  def to_json
      self.inspect.to_json
  end

  def ==(o2)
   if (self.name == o2.name) && (self.name == o2.name) && (self.abbrev == o2.abbrev) && (self.rank == o2.rank) && (self.size == o2.size) then
     return true
   else
     return false
   end    
  end #==

  def <=>(o2)
    if self.name.size < o2.name.size
      -1
    elsif self.name.size > o2.name.size
      1
    else
      0
    end
  end

  def valid_name(name)
    if name.match(/[A-Z][a-z]+/) then
      return true
    else
      return false
    end    
  end
  
 end #class  