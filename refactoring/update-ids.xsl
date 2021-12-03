<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:lm="lionelmoi.org"
    xmlns:uuid="java:java.util.UUID" exclude-result-prefixes="xs math lm uuid" version="3.0">
    <xsl:output method="xml" indent="no" encoding="UTF-8" xml:space="default"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template
        match="/(topic | reference | task | concept)[not(matches(@id, 'l\d+|^warnings$|^reuse_chunks$|^tables^'))]/@id">
        <xsl:attribute name="id">
            <xsl:value-of
                select="'l' || substring-after(xs:string(random-number-generator()?number), '0.')"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
