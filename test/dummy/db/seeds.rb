# frozen_string_literal: true

if Category.count.zero?
  Category.create(name: "Ruby")
  Category.create(name: "Rails")
  Category.create(name: "JavaScript")
end

if Tag.count.zero?
  Tag.create(name: "Programming")
  Tag.create(name: "Management")
  Tag.create(name: "Refactoring")
end
