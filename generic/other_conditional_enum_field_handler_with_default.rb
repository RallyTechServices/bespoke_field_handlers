# Copyright 2015 CA Technologies.  All Rights Reserved.
require 'rallyeif/wrk/field_handlers/field_handler'

module RallyEIF
  module WRK
    module FieldHandlers
      class OtherConditionalEnumFieldHandlerWithDefault < OtherConditionalEnumFieldHandler

        # Add code here to transform in the value from Rally to Other
        # ie., the "in" part refers to the fact that the
        # value of the Rally field is "inbound" to the "Other" system
        # def transform_in(rally_value)
        #   super(rally_value)
        # end

        # Add code here to transform out the value from Other to Rally
        # ie., the "out" part refers to the fact the the
        # value of the Other field is "outbound" from the "Other" system to Rally
        # Notice that the entire artifact is sent in, so will need
        # to get the value for the specific field using @field_name
        def transform_out(artifact)
          begin
          other_value = @connection.get_value(artifact, @field_name)
        rescue ex
          return @rally_default_value
        end
          mapped_value = @enum_mappings[other_value]
          if !mapped_value.nil?
            return mapped_value
          else
            if (other_value.nil?)
              return nil
            else
              return @rally_default_value
            end

          end
        end

        # Add code here if you have other elements to read from the field handler (besides @field_name)
        def read_config(fmh_element)
          # reads FieldName element from config
          # @field_name holds the FieldName value
          super(fmh_element)

          # Iterate through each field handler element
          fmh_element.elements.each do |element|
            if ( element.name == "RallyDefaultValue")
              @rally_default_value = get_element_text(element)
            end
          end
          RallyLogger.debug(self, "OtherFieldHandler read_config #{@rally_default_value}")
        end
      end
    end
  end
end
