#
# This module contains Factory Girl factories for creating model objects in
# test code.
#
# http://github.com/thoughtbot/factory_girl
#

require 'forgery'  



Factory.define :artist do |a|
  a.name "The #{Forgery::Name.full_name} Band"
end


Factory.define :tag do |t|
  t.name Forgery::Basic.color # This will do.
end


Factory.define :venue do |v|
  v.name        "The #{Forgery::Name.company_name} Club"
  v.address     Forgery::Address.street_address
  v.city        Forgery::Address.city
  v.state       Forgery::Address.state
  v.postal_code Forgery::Address.zip
  v.phone       Forgery::Address.phone
end


Factory.define :event do |event|
  event.start_date { 4.days.from_now }
  event.min_cost   Forgery::Monetary.money(:min => 0, :max => 10)
  event.max_cost   Forgery::Monetary.money(:min => 25, :max => 30)
  event.association :venue, :factory => :venue
  event.after_build do |e|
    3.times {|i| e.artists << Factory(:artist) }
  end
end
