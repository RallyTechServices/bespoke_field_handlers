# Copyright 2001-2014 Rally Software Development Corp. All Rights Reserved.

#
# A Jira field handler for converting tags into a multi-select field
#
# <JiraMultiTagFieldHandler>
#   <FieldName>environment</FieldName>
#   <TagPrefix>ENV</TagPrefix>
# </JiraMultiTagFieldHandler>
#

module RallyEIF
  module WRK
    module FieldHandlers

      class JiraMultiTagFieldHandler < RallyEIF::WRK::FieldHandlers::OtherFieldHandler

        attr_accessor :tag_prefix

        def initialize(field_name = nil)
          super(field_name)
        end

        def transform_out(artifact)
          # TODO
          RallyLogger.warn(self, "Cannot transform out this field")
          return nil
        end

        def transform_in(value)
          #
          # Given a collection of Rally tags, turn into a multi select value
          #
          RallyLogger.debug(self,"MultiSelect/Tag field handler start - #{value}")
          
          value_array = []
          value.each do |tag|
            if ( Regexp.new("^#{@tag_prefix}:").match("#{tag}"))
              
              value_array.push("#{tag}".gsub!(/.*:/,""))
            end
          end
          if value_array.length > 0 
            return value_array.join(',')
          end
          return nil
        end

        def read_config(fh_element)
          fh_element.elements.each do |element|
            if (element.name == "TagPrefix")
              @tag_prefix = get_element_text(element)
            elsif (element.name == "FieldName")
              @field_name = get_element_text(element).intern
            else
              raise UnrecoverableException.new("Element #{element.text} not expected in " +
                                                   "JiraMultiTagFieldHandler config", self)
            end
          end
        end

      end

    end
  end
end
