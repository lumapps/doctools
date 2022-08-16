<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:pattern>

        <!--Rule for topic id-->

        <sch:rule context="*[contains(@class, ' topic/topic')]" id="id-pattern">
            <sch:assert
                test="matches(@id, 'l\d+') or ends-with(@id, 'landing') or contains(@id, 'reuse_') or @id = 'warnings' or @id = 'who_can_use' or @id = 'tables'"
                sqf:fix="correctId"> The id "<value-of select="@id"/>" does not follow the right
                pattern. </sch:assert>
            <sqf:fix id="correctId">
                <sqf:description>
                    <sqf:title>Correct @id pattern</sqf:title>
                </sqf:description>
                <sqf:replace match="@id" node-type="attribute" target="id"
                    select="'l' || substring-after(xs:string(random-number-generator()?number), '0.')"
                />
            </sqf:fix>
        </sch:rule>

        <!--Rule for minimum number of list items-->

        <sch:rule context="ul | ol">
            <sch:assert test="count(li) > 1" sqf:fix="addListItem"> A <sch:name/> list must have
                more than one item. </sch:assert>
            <sqf:fix id="addListItem">
                <sqf:description>
                    <sqf:title>Add an item to the list</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="li" position="last-child"/>
            </sqf:fix>
        </sch:rule>

        <!--Rule for paragraph needed in table entries-->

        <sch:rule context="entry[text()[normalize-space()] or *[not(self::p)]] | stentry[text()[normalize-space()] or *[not(self::p)]]">
            <sch:assert test="p"> Text inside a table must be wrapped in a paragraph. </sch:assert>
        </sch:rule>

    </sch:pattern>
</schema>
