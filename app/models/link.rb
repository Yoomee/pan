class Link < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  validates :url, :presence => true, :url => true
  before_save :resolve_host_and_title  
  
  class << self
    def favicon(url)
      "http://g.etfv.co/#{CGI.escape(url)}?defaulticon=lightpng"
    end
  end
  
  def favicon
    self.class.favicon(url)
  end
  
  def to_s
    title.presence || url
  end
  
  private
  def resolve_host_and_title
    self.host = URI.parse(url).host
    self.title = host.sub(/^www\./,'').split(/\./).first.humanize if title.blank?
  end
end
