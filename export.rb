require 'rubygems'
require 'osx/cocoa'
require 'fastercsv'

OSX.require_framework('AddressBook')

csv = FasterCSV.generate do |out|
  
  OSX::ABAddressBook.sharedAddressBook.people.each do |person|
    item = []
    item << person.valueForProperty(OSX::KABFirstNameProperty)
    item << person.valueForProperty(OSX::KABLastNameProperty)
    phone = person.valueForProperty(OSX::KABPhoneProperty)
    if phone
      (0...phone.count).each do |i|
        phone_item = item.dup
        phone_item << '(' + OSX::ABLocalizedPropertyOrLabel(phone.labelAtIndex(i)) + ')'
        out << [phone_item.join(' '), phone.valueAtIndex(i).to_s]
      end
    end
  end
end

puts csv