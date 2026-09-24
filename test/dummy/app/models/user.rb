# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts
  has_and_belongs_to_many :tags
end
