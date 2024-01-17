class Tag < ApplicationRecord
  has_many :post_tag_relations, dependent: :destroy
  has_many :posts, through: :post_tag_relations, dependent: :destroy
  before_validation :downcase_name
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[post_tags posts]
  end

  private

  def downcase_name
    self.name = name.downcase if name.present?
  end
end
