<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <title>Map checks</title>
    <ns uri="http://dita.oasis-open.org/architecture/2005/" prefix="ditaarch"/>
    <pattern id="lang">
        <rule context="*[contains(@class, ' map/map ')]">
            <assert test="@xml:lang" role="warning" sqf:fix="addXmlLang"> Maps must have an
                @xml:lang attribute. </assert>
            <sqf:fix id="addXmlLang">
                <sqf:description>
                    <sqf:title>Add @xml:lang element</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="xml:lang">en</sqf:add>
            </sqf:fix>
        </rule>
    </pattern>
    <pattern id="chunks">
        <rule context="*[contains(@class, ' map/topicref')][@chunk='to-content']">
            <assert test="ancestor::*[contains(@class, ' map/topicref')][not(@chunk='to-content')]" role="error" sqf:fix="removeChunk"> Chunks cannot be nested under chunks. </assert>
            <sqf:fix id="removeChunk">
                <sqf:description>
                    <sqf:title>Remove nested chunk</sqf:title>
                </sqf:description>
                <sqf:delete match="@chunk"/>
            </sqf:fix>
        </rule>
    </pattern>
    <pattern id="root-file">
        <rule
            context="*[@href => ends-with('.dita')][@href => ends-with('-landing.dita') => not()][contains(@class, ' map/topicref')][starts-with(@href, 'release_notes/') => not()]"
            role="error">
            <let name="href" value="@href"/>
            <let name="href-file" value="tokenize($href, '/')[last()]"/>
            <assert test="$href => contains('/')" role="error" id="topic-in-root"> <value-of
                select="$href-file"/> is in the repository root folder. DITA files should not be in
                the repository root folder. Use the Move operation to put it in the appropriate
                folder.</assert>
            <assert test="$href => matches('_\d+\.dita$') => not()" role="warning"
                id="existing-file-name"> You created a file that has the same name as an already
                existing file. Make sure <value-of select="$href-file"/> has a specific name.
            </assert>
        </rule>
    </pattern>
</schema>
