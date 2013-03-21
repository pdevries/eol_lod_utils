# encoding: UTF-8
#!/usr/bin/env ruby
class SpotlightResource
  include Comparable

  attr_accessor :eol_txn, :eol_do, :uri, :support, :types, :surface_form, :offset, :similarity_score, :percentage_of_second_rank


  def initialize(eol_txn, eol_do, uri, support, types, surface_form, offset, similarity_score, percentage_of_second_rank)
      @eol_txn    = eol_txn
      @eol_do     = eol_do
      @uri        = uri
      @support    = support
      @types             = types
      @surface_form      = surface_form
      @offset            = offset
      @similarity_score  = similarity_score
      @percentage_of_second_rank  = percentage_of_second_rank
  end

  def inspect
      return {
      :eol_txn    => @eol_txn,
      :eol_do     => @eol_do,
      :uri        => @uri,
      :support    => @support,
      :types                      => @types,
      :surface_form               => @surface_form,
      :offset                     => @offset,
      :similarity_score           => @similarity_score,
      :percentage_of_second_rank  => @percentage_of_second_rank}
  end

  def to_json
      self.inspect.to_json
  end

  def to_yaml
      self.inspect.to_yaml
  end
  
 end #class  