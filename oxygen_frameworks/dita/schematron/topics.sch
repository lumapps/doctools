<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>Topics checks</title>
    <ns uri="http://dita.oasis-open.org/architecture/2005/" prefix="ditaarch"/>

    <sch:pattern>

        <!--Rule for topic id-->

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

        <!--Rule for minimum number of list items-->

        <sch:rule context="ul | ol">
            <sch:assert test="count(li) > 1" sqf:fix="addListItem transformInParagraph"> A
                <sch:name/> list must have more than one item. </sch:assert>
            <sqf:fix id="addListItem">
                <sqf:description>
                    <sqf:title>Add an item to the list</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="li" position="last-child"/>
            </sqf:fix>
            <sqf:fix id="transformInParagraph">
                <sqf:description>
                    <sqf:title>Transform item in paragraph</sqf:title>
                </sqf:description>
                <sqf:replace match="." target="p" node-type="element">
                    <xsl:apply-templates select="li/node()"/>
                </sqf:replace>
            </sqf:fix>
        </sch:rule>

        <!-- copy template -->
        <xsl:template match="node() | @*">
            <xsl:copy>
                <xsl:apply-templates select="node() | @*"/>
            </xsl:copy>
        </xsl:template>
    </sch:pattern>

    <!-- Rule for paragraph needed in table entries
        <pattern id="p_in_tables">
        <sch:rule context="(entry | stentry)">
            <sch:assert test="count(*[not(contains(@class, '- topic/p '))])=0"> Text inside a table must be wrapped in a paragraph.
            </sch:assert>
            <sch:report test="child::text()"> Test.
            </sch:report>
        </sch:rule>
        </pattern>
        -->

    <!--  Report images without alt text, but avoid reporting warnings when the image has a @conref or @conkeyref, the attribute might be on the target. 
    <pattern id="no_alt_desc_to_images">
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

    <!-- An Image element should be wrapped in a Figure element instead of a Paragraph element 
    <pattern id="images_into_figs">
        <rule context="p">
            <report test="image">An image element should be wrapped in a Figure element instead of a
                Paragraph element.</report>
        </rule>
    </pattern>
    -->

    <!-- An image element should have the @width attribute assigned -->
    <pattern id="image_width_mandatory">
        <rule context="image">
            <assert test="@width">An image element should have the @width attribute
                assigned. 600px should be the maximum.</assert>
        </rule>
    </pattern>


    <!-- Each note element should have the @type or @othertype attribute assigned -->
    <pattern id="add_note_type">
        <rule context="note[not(@conref)]">
            <assert test="@type | @othertype">Each Note element should have the @type (note,
                important, attention) or @othertype (rights) attribute assigned.</assert>
        </rule>
    </pattern>

</schema>
