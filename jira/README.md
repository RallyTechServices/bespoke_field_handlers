## Jira Bespoke Field Handlers

The field handlers in this directory were written at special request 
and meet specific needs.  It is very important to note that these 
field handlers might not be valid for every operation, and while the
descriptions below try to describe the limitations, be careful.


### MultiSelect to Tags

(Actually, this should be Tags to MultiSelect, but since it is a 
Jira one, it goes in this direction.)

#### Description

This field handler will attempt to map tags on an item to one or
more values in a multi-select field in Jira.  It will examine tags 
on the record in Rally and for each tag that begins with the value
defined in the prefix node (followed by a colon) will apply the value
of the tag's name to the right of the column to the multi-select field
in Jira.  

For example, if the tag prefix is "PXS", then a tag on the item called 
"PXS:DataMigration" will attempt to put the value "DataMigration" into
the assigned Jira field.

It is possible to use this for more than one field, mapping multiple 
fields to the Rally Tags field.  Make sure to configure the field handler
separately for each target Jira field.

#### Warnings

This field handler will only work in one direction: copying and updating
FROM Rally to Jira.  Attempting to create tags when coming from Jira to 
Rally will fail.

This field handler sets the multi-select field to equal the array of tag
values, so if on update the field already has a value that does not match
a tag, the value will be removed.

This field handler does not do any validation of the allowed field values in
Jira, so a tag that does not match the allowed values will cause the item
creation/update to fail.

#### Configuration

This field handler's configuration lives in the Connector::OtherFieldHandlers 
node of the XML file.  Be sure to first map the Rally Tags field to the
target Jira field in the FieldMapping section.  We recommend pinning the 
direction to ensure that future changes do not accidentally attempt to copy
the field values back into Rally, like this:

    <Connector>
      <FieldMapping>
    ... other fields ...
          <Field><Rally>Tags</Rally><Other>Environments</Other><Direction>TO_OTHER</Direction></Field>
          <Field><Rally>Tags</Rally><Other>Platform</Other><Direction>TO_OTHER</Direction></Field>
      <FieldMapping>
      
      ... other settings ...
    </Connector>

Note that more than one Jira field can be mapped to the Tags 
selector.  Each one should be given its own field handler configuration.  
In the following example, if a record in Rally has the tags "ENV:Prod", 
"ENV:QA", "PXS", and "PLATFORM:iOS", the connector will attempt to put 
"Prod" and "QA" into the Environments field and "iOS" into the Platform 
field.  The "PXS" tag is ignored because it doesn't have either of the 
mapped prefixes.

    <Connector>
    ... field mapping and rally field handlers ...
    
        <OtherFieldHandlers>
            
          <JiraMultiTagFieldHandler>
            <FieldName>Environments</FieldName>
            <TagPrefix>ENV</TagPrefix>
          </JiraMultiTagFieldHandler>
          
          <JiraMultiTagFieldHandler>
            <FieldName>Platform</FieldName>
            <TagPrefix>PLATFORM</TagPrefix>
          </JiraMultiTagFieldHandler>
          
        </OtherFieldHandlers>
    </Connector>

