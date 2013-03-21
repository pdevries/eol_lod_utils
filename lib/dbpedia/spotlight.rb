# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dbpedia/spotlight/version')
require File.expand_path('../lib/dbpedia/spotlight/client')

module DBpedia
  class << self
    def Spotlight(endpoint=nil)
      DBpedia::Spotlight::Client.new(endpoint)
    end
  end
end
