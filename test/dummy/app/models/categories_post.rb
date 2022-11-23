# frozen_string_literal: true

class CategoriesPost < ApplicationRecord
  belongs_to :category
  belongs_to :post
end
