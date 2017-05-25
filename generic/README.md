bespoke_field_handlers
======================

## Generic Bespoke Field Handlers

The field handlers in this directory were written at special request
and meet specific needs.  It is very important to note that these
field handlers might not be valid for every operation, and while the
descriptions below try to describe the limitations, be careful.


### OtherConditionalEnumFieldHandlerWithDefault

#### Description

This field handler behaves like the OtherConditionalEnumFieldhandler except for
instead of passing the value through to Rally when going from Other to Rally,
it will use the configured Default value ("RallyDefaultValue").  

The goal of this field handler is to map values that are unwanted to a
default value.  For example, a user wants to migrate data into Agile Central
from a System.  The user wants to map the releases for the current year, but
wants to map all other items in older releases to one "Archive" release in Rally.  

The configuration for this would look like:  
<Connector>

... field mapping and rally field handlers ...

<OtherFieldHandlers>
  <OtherConditionalEnumFieldHandlerWithDefault>
    <FieldName>RQ_TARGET_REL</FieldName>
      <Mappings>
        <Field><Rally>Release 2 (5,6,7)</Rally><Other>xyz</Other></Field>
      </Mappings>
      <OtherDefaultValue>Release 3 (8,9,10)</OtherDefaultValue>
      <RallyDefaultValue>Release 1 (1,2,3,4)</RallyDefaultValue>
  </OtherConditionalEnumFieldHandlerWithDefault>
</OtherFieldHandlers>

#### Warnings

This field handler was written to work in one direction (copying and updating
FROM OTHER_TO_RALLY) but could be modified to manage bidirectional behavior.  

Currently, the default value will be applied when going from the Other
system to Agile Central.  However, going from Agile Central to the
Other system will result in the default behavior of the
OtherConditionalEnumFieldHandler, which will be passing the rally value
through if it is not mapped.

#### Configuration

This field handler's configuration lives in the Connector::OtherFieldHandlers
node of the XML file.  Be sure to first map the Rally field to the
target other system field in the FieldMapping section.  We recommend pinning the
direction to ensure that future changes do not accidentally attempt to copy
the field values back into the other system:

    <Connector>
      <FieldMapping>
    ... other fields ...
          <Field><Rally>Release</Rally><Other>RQ_TARGET_REL</Other></Field>
      <FieldMapping>

      ... other settings ...

    ... rally field handlers ...

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