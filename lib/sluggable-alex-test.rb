module Sluggable

  def self.included(base)
    base.send(:include, InstanceExtend)
    base.extend ClassExtend
    base.class_eval do
      auto_included
    end
  end

  module InstanceExtend
    def to_param
      self.slug
    end

    def generate_slug
      str = to_slug(self.sluggable)
      count = 2
      obj = Post.where(slug: str).first
      while obj && obj != self
        str_try = str + "-" + count.to_s
        obj = Post.where(slug: str_try).first
        count += 1
      end
      self.slug = str_try
    end
 
    def to_slug(name)
      #strip the string
      ret = name.strip
 
      #blow away apostrophes
      ret.gsub! /['`]/,""
  
      # @ --> at, and & --> and
      ret.gsub! /\s*@\s*/, " at "
      ret.gsub! /\s*&\s*/, " and "
 
      #replace all non alphanumeric with dash
      ret.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
 
      #convert double dashes to single
      ret.gsub! /-+/,"-"
 
      #strip off leading/trailing dash
      ret.gsub! /\A[-\.]+|[-\.]+\z/,""
 
      ret.downcase
    end
  end

  module ClassExtend
    def auto_included
      after_validation :generate_slug
    end
  end

end

