<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>Topics checks</title>
    <ns uri="http://dita.oasis-open.org/architecture/2005/" prefix="ditaarch"/>

    <sch:pattern>
        <!--Rule for topic ID -->
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

    <sch:pattern>
        <!--Rule for minimum number of list items-->
        <sch:rule context="ul | ol">
            <sch:assert test="count(li) > 1" sqf:fix="addListItem transformInParagraph"> A
                <sch:name/> list must contain more than one item. </sch:assert>
            <sqf:fix id="addListItem">
                <sqf:description>
                    <sqf:title>Add an item to the list</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="li" position="last-child"/>
            </sqf:fix>
            <sqf:fix id="transformInParagraph">
                <sqf:description>
                    <sqf:title>Transform the item into a paragraph</sqf:title>
                </sqf:description>
                <sqf:replace match="." target="p" node-type="element">
                    <xsl:apply-templates select="li/node()"/>
                </sqf:replace>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <!-- Rules for reporting a list following a list -->
        <!-- Report ul after ul -->
        <sch:rule context="*[contains(@class, ' topic/ul ')]">
            <sch:report test="
                    following-sibling::node()[1]
                    [contains(@class, ' topic/ul ') or
                    (self::text() and normalize-space(.) = '') and
                    following-sibling::node()[1][self::*][contains(@class, ' topic/ul ')]]"
                role="warn" sqf:fix="mergeLists"> Two consecutive unordered lists. You can probably
                merge them into one. </sch:report>
        </sch:rule>

        <!-- Report ol after ol -->
        <sch:rule context="*[contains(@class, ' topic/ol ')]">
            <sch:report test="
                    following-sibling::node()[1]
                    [contains(@class, ' topic/ol ') or
                    (self::text() and normalize-space(.) = '') and
                    following-sibling::node()[1][self::*][contains(@class, ' topic/ol ')]]"
                role="warn" sqf:fix="mergeLists"> Two consecutive ordered lists. You can probably
                merge them into one. </sch:report>
        </sch:rule>

        <!-- Report dl after dl -->
        <sch:rule context="*[contains(@class, ' topic/dl ')]">
            <sch:report test="
                    following-sibling::node()[1]
                    [contains(@class, ' topic/dl ') or
                    (self::text() and normalize-space(.) = '') and
                    following-sibling::node()[1][self::*][contains(@class, ' topic/dl ')]]"
                role="warn" sqf:fix="mergeLists"> Two consecutive definition lists. You can probably
                merge them into one. </sch:report>
        </sch:rule>

        <sqf:fixes>
            <!-- Merge the two lists into one -->
            <sqf:fix id="mergeLists">
                <sqf:description>
                    <sqf:title>Merge lists into one</sqf:title>
                </sqf:description>
                <sqf:add position="last-child">
                    <xsl:apply-templates mode="copyExceptClass"
                        select="following-sibling::*[1]/node()"/>
                </sqf:add>
                <sqf:delete match="following-sibling::*[1]"/>
            </sqf:fix>

            <!-- Wrap the current element in a paragraph. -->
            <sqf:fix id="wrapInParagraph" use-when="not(parent::p)">
                <sqf:description>
                    <sqf:title>Wrap "<sch:name/>" element in a paragraph</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="p" position="after">
                    <xsl:apply-templates mode="copyExceptClass" select="."/>
                </sqf:add>
                <sqf:delete/>
            </sqf:fix>

            <!-- Split the paragraph before and after and leve the current element as the only child in its parent paragraph. -->
            <sqf:fix id="splitParagraphBeforeAndAfter" use-when="parent::p">
                <sqf:description>
                    <sqf:title>Wrap "<sch:name/>" element in its own paragraph</sqf:title>
                </sqf:description>
                <sch:let name="currentNode" value="."/>
                <sch:let name="nodesAfter" value="following-sibling::node()"/>
                <sch:let name="nodesBefore" value="preceding-sibling::node()"/>
                <!-- Add the content that is after the current element in a separate paragraph -->
                <sqf:add match="parent::node()" node-type="element" target="p" position="after"
                    use-when="count($nodesAfter) > 1 or (count($nodesAfter) = 1 and normalize-space($nodesAfter) != '')">
                    <xsl:apply-templates mode="copyExceptClass" select="$nodesAfter"/>
                </sqf:add>
                <!-- Add the content that is before the current element in a separate paragraph -->
                <sqf:add match="parent::node()" node-type="element" target="p" position="after">
                    <xsl:apply-templates mode="copyExceptClass" select="$currentNode"/>
                </sqf:add>
                <!-- Add the the current element in a separate paragraph -->
                <sqf:add match="parent::node()" node-type="element" target="p" position="after"
                    use-when="count($nodesBefore) > 1 or (count($nodesBefore) = 1 and normalize-space($nodesBefore) != '')">
                    <xsl:apply-templates mode="copyExceptClass" select="$nodesBefore"/>
                </sqf:add>
                <!-- Delete the parent node. -->
                <sqf:delete match="parent::node()"/>
            </sqf:fix>
        </sqf:fixes>
    </sch:pattern>

    <!-- An image element should have the @width attribute assigned -->
    <pattern id="image_width_mandatory">
        <rule context="image">
            <assert test="@width">An image must have a @width attribute. Do not exceed 600 px.
                Boilerplates must have a width of 20 px.</assert>
        </rule>
    </pattern>

    <!-- Each note element should have the @type or @othertype attribute assigned -->
    <pattern id="add_note_type">
        <rule context="note[not(@conref)][not(@conkeyref)]">
            <assert test="@type | @othertype">All notes should have the @type (note, important,
                attention) or @othertype (rights) attribute assigned.</assert>
        </rule>
    </pattern>



    <!-- All images must be wrapped in a fig element (except boilerplates). A fig element cannot be wrapped in a paragraph tag. 
    <sch:pattern> 
        <sch:rule context="*[contains(@class, 'topic/image')]" role="warn">
            <sch:report test="not(parent::fig)">An image must be wrapped in a figure
                element.</sch:report>
        </sch:rule>
        <sch:rule context="*[contains(@class, 'topic/fig')]" role="warn">
            <sch:assert test="not(parent::p)">A figure cannot be inside of a paragraph
                element.</sch:assert>
        </sch:rule>
    </sch:pattern>    -->



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



    <!-- copy template -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <!-- copy template without the class -->
    <xsl:template match="node() | @*" mode="copyExceptClass">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="node() | @*" mode="copyExceptClass"/>
        </xsl:copy>
    </xsl:template>
</schema>
