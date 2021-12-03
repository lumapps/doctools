<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">

    <xsl:import href="../../common/outputs.xsl"/>

    <xsl:mode name="cleanup-json" on-no-match="shallow-copy" exclude-result-prefixes="#all"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions"/>

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:param name="ditamap-json" select="'../build/input.json'"/>

    <xsl:param name="json" select="unparsed-text($ditamap-json)"/>

    <xsl:param name="json-xml" select="json-to-xml($json)"/>

    <xsl:variable name="json-xml-clean">
        <xsl:apply-templates select="$json-xml" mode="cleanup-json"/>
    </xsl:variable>

    <xsl:template match="*:map" mode="cleanup-json">
        <map>
            <xsl:apply-templates select="node() | @*" mode="cleanup-json"/>
        </map>
    </xsl:template>

    <xsl:template match="*" mode="cleanup-json">
        <xsl:element name="{@key}">
            <xsl:apply-templates select="node()" mode="cleanup-json"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="xsl:initial-template">
        <xsl:apply-templates select="$json-xml-clean"/>
    </xsl:template>

    <xsl:template match="/">

        <xsl:result-document href="/Users/lionelmoizeau/workspace/microsoft-graph-docs/microsoft.ditamap" format="ditaDTDmap13">


            <map>
                <title>Microsoft graph api</title>
                <xsl:apply-templates select="map"/>
            </map>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="map">

        <xsl:comment select="href"/>
        <topicref format="md">
            <xsl:apply-templates select="href"/>
            <xsl:apply-templates select="*"/>
        </topicref>
    </xsl:template>

    <xsl:template match="href">
        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="contains(., '?toc')">
                    <xsl:value-of select="'concepts/' || substring-before(., '?toc') => substring-after('/graph/') || '.md'"/>
                </xsl:when>
                <xsl:when test="starts-with(., 'resources') or starts-with(., '/resources')">
                    <xsl:value-of select="'api-reference/v1.0/' || ."/>
                </xsl:when>
                <xsl:when test="starts-with(., 'api')">
                    <xsl:value-of select="'api-reference/v1.0/' || ."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'concepts/' || ."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>



        <xsl:attribute name="href" select="$href"/>
    </xsl:template>

</xsl:stylesheet>
