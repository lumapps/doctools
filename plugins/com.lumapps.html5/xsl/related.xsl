<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" exclude-result-prefixes="xs related-links ditamsg dita-ot">

    <xsl:template name="ul-child-links">
        <xsl:variable name="children"
            select="
                descendant::*[contains(@class, ' topic/link ')]
                [@role = ('child', 'descendant')]
                [not(parent::*/@collection-type = 'sequence')]
                [not(ancestor::*[contains(@class, ' topic/linklist ')])]"/>
        <xsl:if test="$children">
            <div class="docWidget docWidget-childlinks">
                <ul class="ullinks">
                    <!--once you've tested that at least one child/descendant exists, apply templates to only the unique ones-->
                    <xsl:apply-templates select="$children[generate-id(.) = generate-id(key('link', related-links:link(.))[1])]"/>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="ol-child-links">
        <xsl:variable name="children"
            select="
                descendant::*[contains(@class, ' topic/link ')]
                [@role = ('child', 'descendant')]
                [parent::*/@collection-type = 'sequence']
                [not(ancestor::*[contains(@class, ' topic/linklist ')])]"/>
        <xsl:if test="$children">
            <div class="docWidget docWidget-childlinks">
                <ol class="olchildlinks">
                    <!--once you've tested that at least one child/descendant exists, apply templates to only the unique ones-->
                    <xsl:apply-templates select="$children[generate-id(.) = generate-id(key('link', related-links:link(.))[1])]"/>
                </ol>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/link ')][@role = ('child', 'descendant')]" priority="2" name="topic.link_child">
        <li class="ulchildlink">
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'ulchildlink'"/>
            </xsl:call-template>
            <!-- Allow for unknown metadata (future-proofing) -->
            <xsl:apply-templates select="*[contains(@class, ' topic/data ') or contains(@class, ' topic/foreign ')]"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <strong>
                <xsl:apply-templates select="." mode="related-links:unordered.child.prefix"/>
                <xsl:apply-templates select="." mode="add-link-highlight-at-start"/>
                <a>
                    <xsl:apply-templates select="." mode="add-linking-attributes"/>
                    <xsl:apply-templates select="." mode="add-hoverhelp-to-child-links"/>

                    <!--use linktext as linktext if it exists, otherwise use href as linktext-->
                    <xsl:choose>
                        <xsl:when test="*[contains(@class, ' topic/linktext ')]">
                            <xsl:apply-templates select="*[contains(@class, ' topic/linktext ')]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--use href-->
                            <xsl:call-template name="href"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <xsl:apply-templates select="." mode="add-link-highlight-at-end"/>
            </strong>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>

            <!--add the description on the next line, like a summary-->
            <p>
                <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"/>
            </p>
        </li>
    </xsl:template>

</xsl:stylesheet>
