class Repository < ActiveRecord::Base

  belongs_to :user
  before_validation :generate_shortcode, :if => "self.new_record?"

  validates :name, :presence => true
  validates :shortcode, :presence => true, :uniqueness => true
  validates :name, :uniqueness => { :scope => :user_id }

  def generate_shortcode
    begin
      code = ([
        ("a".."z").to_a,
        ("A".."Z").to_a,
        ("0".."9").to_a].flatten
      ).sort_by{rand}[0,6].join
    end until( code.to_i.zero? and not code == '0' * 6 and Repository.find_by_shortcode(code).nil? )
    self.shortcode = code
  end
end
