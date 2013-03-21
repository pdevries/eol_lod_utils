# encoding: UTF-8
#!/usr/bin/env ruby

class TaxonDoText
  include Comparable

  attr_accessor :eol_txn, :data_object, :text


  def initialize(eol_txn, data_object, text)
      @eol_txn     = eol_txn
      @data_object = data_object
      @text        = text
  end

  def inspect
      return {:eol_txn => @eol_txn, :data_object => @data_object, :text => @text}
  end

  def to_json
      self.inspect.to_json
  end

  def to_yaml
      self.inspect.to_yaml
  end
  
 end #class  