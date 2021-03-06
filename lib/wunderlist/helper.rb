module Wunderlist
  module Helper

    require 'active_support/inflector'

    def to_hash
      i_vs = self.instance_variables
      i_vs.delete_if {|i_v| i_v.to_s == '@api'}
      hash = {}
      i_vs.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) } 

      hash

    end

    def update
      model_name = get_plural_model_name
      self.api.request :put, "api/v1/#{model_name}/#{self.id}", self.to_hash
    end
    
    def save
      model_name = get_plural_model_name
      if self.id.nil?
        res = self.api.request :post, "api/v1/#{model_name}", self.to_hash
      else
        res = self.update
      end
      set_attrs(res)
    end

    def destroy
      model_name = get_plural_model_name
      self.api.request :delete, "api/v1/#{model_name}/#{self.id}", {:revision => self.revision}
      self.id = nil

      self

    end

    private

    def get_plural_model_name
      self.class.to_s.gsub('Wunderlist::','').tableize
    end

  end
end

class Hash

  def stringify_keys
    self.replace(self.inject({}){|a,(k,v)| a[k.to_s] = v; a})
  end

end

