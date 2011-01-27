require File.expand_path('../traktor/client', __FILE__)

module Traktor

  def self.client(options={})
    Traktor::Client.new(options)
  end

end