class Lookup < ActiveRecord::Base
  
  def self.list_for(category)
    root = Lookup.find_by_code(category)
    Lookup.find_all_by_category(root.id)
  end
  
  def self.code_for(category, code)
    root = Lookup.find_by_code(category)
    Lookup.find_by_category_and_code(root, code)
  end
  
end
