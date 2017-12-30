class Lookup < ApplicationRecord
  def self.list_for(category)
    root = Lookup.find_by(code: category)
    Lookup.where(category: root.id)
  end

  def self.code_for(category, code)
    root = Lookup.find_by(code: category)
    Lookup.find_by(category: root, code: code)
  end
end
