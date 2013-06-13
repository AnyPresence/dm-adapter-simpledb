require 'dm-types'

# NOTE: Do not try to clear SdbArray properties by assigning nil. Instead,
# assign an empty array:
#
#  resource.array_prop = []
#  resource.save
#
# The reason has to do with DataMapper's lazy-load handling - a lazy-loaded
# property has a value of nil until it is loaded. If you assign nil, DM thinks
# that 
module DataMapper
  class Property
    class ArrayWrapper
      def initialize(value)
        @value = value
      end
      def to_ary
        @value
      end
      def to_s
        @value.to_s
      end
    end
    
    class SdbArray < DataMapper::Property::Object
      primitive ::Object
      lazy      true
      
      def custom?
        true
      end
      
      def load(value)
        return if value.nil? 
        return value.to_ary if value.kind_of?(ArrayWrapper)
        raise "oops!"
      end

      def dump(value)
        return if value.nil?
        if value.kind_of?(ArrayWrapper)
          value
        else
          ArrayWrapper.new(value) 
        end
      end

      def typecast(value)
        return if value.nil?
        if value.kind_of?(ArrayWrapper)
          value
        elsif value.kind_of?(::Array)
          ArrayWrapper.new(value) 
        elsif value.kind_of?(::String)
          array = if value.start_with?("[") && value.end_with?("]")
            split_into_array(value)
          else 
            [value]
          end
          ArrayWrapper.new(array)
        else
          raise "what do we do here? #{value.inspect}"
        end
      end
      
      def split_into_array(array_string) 
        if array_string.size == 2
          array = []
        else
          array = array_string[1..-2].split(',').map{|s| chop_double_quotes(s.strip) }
        end
      end
      
      def chop_quotes(string)
        if (string.start_with?("\"") && string.end_with?("\""))
          string[1..-2] 
        else
          string
        end
      end
    end 
  end
end
