module TimestampedBoolean
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def timestamped_boolean(field_name, verb_name=nil)
      bool   = field_name.to_s.sub(/_at$/, '')
      action = verb_name ? verb_name.to_s : bool.sub(/ed$/, '')
      
      define_method(bool.to_sym) do 
        ! send(field_name.to_sym).nil?
      end
      alias_method (bool + '?').to_sym, bool.to_sym
      
      define_method(action.to_sym) do
        send((field_name.to_s + '=').to_sym, Time.now)
      end
      
      define_method (action + '!').to_sym do
        send action.to_sym
        send :save!
      end
    end
  end
end