

module RallyEIF
  module WRK

    class RallyConnection < RallyEIF::WRK::Connection

      def get_parent_id(story)
      #  parent_story = story.Parent
        parent_story = story.PortfolioItem
        return nil if parent_story.nil?
        parent_story.refresh
        return parent_story.FormattedID
      end
    end
  end
end
