<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="outputs.xsl"/>


    <xsl:template match="resources">
        <xsl:result-document href="lokalise.ditamap" format="ditaDTDmap13">
            <map>
                <title>Lokalise keys</title>
                <xsl:apply-templates select="/resources/string"/>
            </map>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="string">
        <keydef keys="{@name}">
            <topicmeta>
                <keywords>
                    <keyword>
                        <xsl:value-of select="."/>
                    </keyword>
                </keywords>
            </topicmeta>
        </keydef>
    </xsl:template>

</xsl:stylesheet>
