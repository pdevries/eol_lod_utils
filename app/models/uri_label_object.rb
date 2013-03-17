# encoding: UTF-8
#!/usr/bin/env ruby
class UriLabelObject
  include Comparable

  attr_accessor :uri, :label


  def initialize(uri, label)
      @uri        = uri
      @label      = label
  end

  def inspect
      return {:uri => @uri, :label => @label}
  end

  def to_json
      self.inspect.to_json
  end

  def to_yaml
      self.inspect.to_yaml
  end
  
 end #class  