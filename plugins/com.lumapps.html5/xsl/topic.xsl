<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">


    <xsl:template name="gen-topic">
        <xsl:param name="nestlevel" as="xs:integer">
            <xsl:choose>
                <!-- Limit depth for historical reasons, could allow any depth. Previously limit was 5. -->
                <xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 9">9</xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="parent::dita and not(preceding-sibling::*)">
                <!-- Do not reset xml:lang if it is already set on <html> -->
                <!-- Moved outputclass to the body tag -->
                <!-- Keep ditaval based styling at this point (replace DITA-OT 1.6 and earlier call to gen-style) -->
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="commonattributes">
                    <xsl:with-param name="default-output-class">
                        <xsl:choose>
                            <xsl:when test="$nestlevel = 1">
                                <xsl:value-of select="concat('nested', $nestlevel, ' docWidget docWidget-body')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('nested', $nestlevel)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="gen-toc-id"/>
        <xsl:call-template name="setidaname"/>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/body ')]" name="topic.body">
        <xsl:variable name="nestlevel" as="xs:integer">
            <xsl:sequence select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
        </xsl:variable>
        <div>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class">
                    <xsl:if test="$nestlevel = 1">
                        <xsl:value-of select="' docWidget docWidget-body'"/>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <!-- here, you can generate a toc based on what's a child of body -->
            <!--xsl:call-template name="gen-sect-ptoc"/-->
            <!-- Works; not always wanted, though; could add a param to enable it.-->

            <!-- Insert prev/next links. since they need to be scoped by who they're 'pooled' with, apply-templates in 'hierarchylink' mode to linkpools (or related-links itself) when they have children that have any of the following characteristics:
         - role=ancestor (used for breadcrumb)
         - role=next or role=previous (used for left-arrow and right-arrow before the breadcrumb)
         - importance=required AND no role, or role=sibling or role=friend or role=previous or role=cousin (to generate prerequisite links)
         - we can't just assume that links with importance=required are prerequisites, since a topic with eg role='next' might be required, while at the same time by definition not a prerequisite -->

            <!-- Added for DITA 1.1 "Shortdesc proposal" -->
            <!-- get the abstract para -->
            <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/abstract ')]" mode="outofline"/>

            <!-- get the shortdesc para -->
            <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/shortdesc ')]" mode="outofline"/>

            <!-- Insert pre-req links - after shortdesc - unless there is a prereq section about -->
            <xsl:apply-templates select="following-sibling::*[contains(@class, ' topic/related-links ')]" mode="prereqs"/>

            <xsl:apply-templates/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
        </div>
    </xsl:template>

</xsl:stylesheet>
