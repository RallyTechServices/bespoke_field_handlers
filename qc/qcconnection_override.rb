#
# The purpose of this override is to support the usage of the CrosslinkUrl field
# on the QC connection so that the QC link is updated in the corresponding Rally object.
#
module RallyEIF
  module WRK
    class QCConnection

    def get_object_link(artifact)
            #s A link to a QC item looks like:
            #    <a href="http://[qc_server_url]/??/??/ ...">bug_id</a>"

            if @artifact_type == :defect
              #return <qc link to the defect>
            elsif @artifact_type == :test
              #return <qc link to the test>
            end

            #if no other hits, return story string
            return "<a href=\”td://#{@project}.#{@domain}.alm.corp.sprint.com/qcbin/RequirementsModule-0001991264320?EntityType=IRequirement&EntityID=#{artifact.id}\”>ALM ID #{artifact.id}</a>"
          end
    end
  end
end
