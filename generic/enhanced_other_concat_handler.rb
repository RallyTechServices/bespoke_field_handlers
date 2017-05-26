# Copyright 2015 CA Technologies.  All Rights Reserved.
require 'rallyeif/wrk/field_handlers/field_handler'

module RallyEIF
  module WRK
    module FieldHandlers
      class OtherEnhancedConcatFieldHandler < OtherConcatFieldHandler

        def transform_out(artifact)

          base_val = @connection.get_value(artifact, @field_name)
          ret_val = "#{base_val}"
          @field_list.each do |field_nm|
            next_val = @connection.get_value(artifact, field_nm)
            if !@exclude_values.include?(next_val.downcase)
                ret_val = " #{next_val} #{@delimiter} #{ret_val}"
            end
          end
          ret_val
        end

        # Add code here if you have other elements to read from the field handler (besides @field_name)
        def read_config(fmh_element)
          # reads FieldName element from config
          # @field_name holds the FieldName value

           exclude_values = nil
           @exclude_values = []
           @delimiter = "<br/>"
           @field_list = []

          fmh_element.elements.each do |element|
            if element.name == "FieldName"
              RallyLogger.debug(self, "FieldName element: #{element}")
              @field_name = get_element_text(element).intern
            end

            if element.name == "ConcatFields"
              RallyLogger.debug(self, "ConcatFields element: #{element}")
              element.elements.each do |field_elem|
                concat_field = nil
                concat_field = field_elem.text if field_elem.name == "Field"
                next if concat_field.nil? || concat_field.empty?
                @field_list.push(concat_field.intern)
              end
            end

            if element.name == "ExcludeValues"
              exclude_values = get_element_text(element)
              RallyLogger.debug(self, "ExcludeValues element: #{exclude_values}")
              @exclude_values = exclude_values.split(",")
              @exclude_values.map! do |v|
                v.downcase
              end
            end

            if element.name == "Delimiter"
              @delimiter = get_element_text(element)
            end
          end

          RallyLogger.debug(self, "OtherEnhancedConcatFieldHandler exclude_values: #{@exclude_values}")
          RallyLogger.debug(self, "OtherEnhancedConcatFieldHandler delimiter: #{@delimiter}")

        end
      end
    end
  end
end
