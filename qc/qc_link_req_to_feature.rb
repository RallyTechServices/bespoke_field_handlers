# this overridden versioon of the MirrorStoryHierarchyInQC was written for the
# purpose of linking requirements (copied from AC Stories) to a Requirement Folder that
# represents the AC Feature that the story was a child of.
#
# The handler assumes that the only requirements copied from AC are direct children
# of Portfolio ITem Feature, and will break the Post Service Action functionality originally
# intended for the MirrorStoryHierarchyInQC Post Service Action
#
module RallyEIF
  module WRK

    class RallyConnection < RallyEIF::WRK::Connection

      def get_parent_id(story)
      #  parent_story = story.Parent
        parent_story = story.PortfolioItem
        return nil if parent_story.nil?
        parent_story.refresh
        return parent_story.ObjectID
      end
    end
  end
end

module RallyEIF
  module WRK

    module PostServiceActions

      class MirrorStoryHierarchyInQC < PostServiceAction

        def process_parents(story_list)
          RallyLogger.debug(self, "Running post process to link story to portfolio hierarchy in QC...")
          story_list.each do |story|
            story.refresh()
            rally_id = @rally_connection.get_id_value(story)
            qc_item = @other_connection.find_by_external_id(rally_id)
            parent_rally_id = @rally_connection.get_parent_id(story)
            unless parent_rally_id.nil?
              #qc_parent = @other_connection.find_by_external_id(parent_rally_id)
              qc_parent = @other_connection.find_by_external_id(parent_rally_id)
              @other_connection.set_parent_req(qc_item.id, qc_parent.id)
            end

            rally_children = @rally_connection.get_linked_children_ids(story)
            if rally_children.length > 0
              rally_children.each do |child_id|
                qc_child = @other_connection.find_by_external_id(child_id)
                @other_connection.set_parent_req(qc_child.id, qc_item.id)
              end
            end
          end
          RallyLogger.debug(self, "Completed running post process to mirror Rally portfolio hierarchy in QC.")
        end
    end
  end
end
end
