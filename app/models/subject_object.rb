# encoding: UTF-8
#!/usr/bin/env ruby

class SubjectObject
  include Comparable

  attr_accessor :subject, :object


  def initialize(subject, object)
      @subject     = subject
      @object      = object
  end

  def inspect
      return {:subject => @subject, :object => @object}
  end

  def to_json
      self.inspect.to_json
  end

  def to_yaml
      self.inspect.to_yaml
  end
  
 end #class  