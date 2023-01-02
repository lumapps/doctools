<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>Topics checks</title>
    <ns uri="http://dita.oasis-open.org/architecture/2005/" prefix="ditaarch"/>

    <sch:pattern>
        <sch:rule context="*[contains(@class, ' topic/topic')]" id="id-pattern">
            <sch:assert
                test="matches(@id, 'l\d+') or ends-with(@id, 'landing') or contains(@id, 'reuse') or @id = 'tables'"
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
    </sch:pattern>

    <!--  
    <pattern id="no_alt_desc">
        EXM-28035 Avoid reporting warnings when the image has a @conref or @conkeyref, the attribute might be on the target. 
        <rule context="*[contains(@class, 'topic/image')][not(@conref)][not(@conkeyref)]"
            id="accessibility">
            <assert test="@alt | alt" role="warning" sqf:fix="addAltElem"> Images must have text
                alternatives that describe the information or function represented by them.</assert>

            <sqf:fix id="addAltElem">
                <sqf:description>
                    <sqf:title>Add alt element</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="alt">
                    <xsl:processing-instruction name="oxy-placeholder">content="Insert alternate text here"</xsl:processing-instruction>
                </sqf:add>
            </sqf:fix>
        </rule>
    </pattern>
-->
</schema>
