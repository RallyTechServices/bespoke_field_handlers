# Copyright 2001-2014 Rally Software Development Corp. All Rights Reserved.

#require 'yeti/field_handlers/other_field_handler'
#require 'rexml/document'

#             <QCReqLink2FieldHandler>
#                 <FieldName>BG_BUG_ID</FieldName>
#                 <ReqRallyIDField>RQ_USER_07</ReqRallyIDField>
#                 <ReqLinkedField>BG_LINKED_REQ</ReqLinkedField>
#             </QCReqLink2FieldHandler>
#
# *** This is from the code provided by JP Kole and John Martin in the Rally Experiments
# private repo ***

module RallyEIF
  module WRK
    module FieldHandlers

      class QCReqLink2FieldHandler < QCReqLinkFieldHandler #< RallyEIF::WRK::FieldHandlers::OtherFieldHandler

        def read_config(fh_element)
        #  super(fh_element)

          fh_element.elements.each do |element|
            if ( element.name == "FieldName" || element.name == "Field")
                @field_name = get_element_text(element).intern
            end
            if (element.name == "ReqRallyIDField")
              @rq_rally_id = get_element_text(element)
            end
            if (element.name == "ReqLinkedField")
              @rq_link_field_name = get_element_text(element).to_sym
            end
          end

          if (VALID_REFERENCES.index(@rq_link_field_name) == nil)
            raise UnrecoverableException.new("Element 'ReqLinkedField' for QCReqLink2FieldHandler - #{@rq_link_field_name} must be from " +
                                                 "the following set #{VALID_REFERENCES}", self)
          end

          if (@rq_rally_id.nil? || !@rq_rally_id.to_s.include?("RQ_USER"))
            raise UnrecoverableException.new("QCReqLink2FieldHandler for #{@field_name} must have a RQ_USER_NN field for the Rally ID.", self)
          end

        end
      end
    end
  end
end
