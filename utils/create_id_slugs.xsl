<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">
    <xsl:import href="../common/outputs.xsl"/>

    <xsl:mode name="cleanup-json" on-no-match="shallow-copy" exclude-result-prefixes="#all"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions"/>

    <xsl:param name="map-name" required="yes"/>
   
    <xsl:param name="ditamap-json" select="'/Users/lionelmoizeau/workspace/lumapps-dita/sources/html5/'|| $map-name ||'/ditaMap.json'"/>
    <xsl:param name="output"/>
    

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

    <xsl:template match="*:array" mode="cleanup-json">
        <xsl:variable name="elmt" select="@key"/>
        <xsl:for-each select="*">
            <xsl:element name="{$elmt}">
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="cleanup-json">
        <xsl:element name="{@key}">
            <xsl:apply-templates select="node()" mode="cleanup-json"/>
        </xsl:element>
    </xsl:template>


    <xsl:template name="xsl:initial-template">
        <xsl:apply-templates select="$json-xml-clean"/>
    </xsl:template>



    <xsl:template match="map">

        <xsl:result-document href="{$map-name || '-' || $output}.dita" format="ditaDTDtopic13">


            <topic id="{section_slug}">
                <title><xsl:value-of select="section_slug"/> IDs and slugs</title>
                <prolog>

                    <xsl:apply-templates select="map/*[id]" mode="ids"/>

                </prolog>
            </topic>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="ids">
        <resourceid id="{@key}" appid="{id}"/>
    </xsl:template>
</xsl:stylesheet>
