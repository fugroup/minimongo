module Minimongo
  module Query

    # # # # # # # # # # # # #
    # This is the tiniest possible implementation of a mongodb library.
    # Instead of doing $db[:models].find, you can now do find(:models),
    # and there's some extra short cuts like first, last, all and count.
    #
    # Intended use is with tests, especially Fugroup/Futest, but can also
    # be used for full fledged applications if you don't want an ORM.
    #
    # If you need models for Minimongo, check out https://github.com/fugroup/modelize
    #
    # If you need an ORM, check out https://github.com/fugroup/mongocore
    #

    # Creates a BSON::ObjectId from a string, or a new one
    # Use with: oid(string), or oid, oid(:new), oid(nil) to create a new BSON::ObjectId
    def oid(v = nil); BSON::ObjectId.from_string(v) rescue BSON::ObjectId.new; end

    # Find, insert, update, delete
    [:find, :insert, :update, :delete].each{|m| class_eval %Q{def #{m}(*g); g[1] = {:_id => oid(g[1])} if g[1].is_a?(String); Minimongo.db[g.shift].#{m != :find ? "#{m}_one" : m}(*g); end}}

    # First, last, count, all
    def first(*g); find(*g).limit(-1).first; end
    def last(*g); find(*g).limit(-1).sort(:$natural => -1).first; end
    def count(*g); find(*g).count; end
    def all(*g); find(*g).to_a; end

  end
end
