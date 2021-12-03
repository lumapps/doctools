<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">

    <xsl:output method="xml"/>

    <xsl:param name="json-file" as="xs:string" select="'/Users/lionelmoizeau/workspace/lumapps-dita/sources/html5/ditaMap.json'"/>

    <!--<xsl:param name="json-file" as="xs:string" select="'file:/Users/lionelmoizeau/workspace/lumapps-dita/sources/html5/Untitled1.json'"/>-->

    <xsl:variable name="json-text" select="unparsed-text($json-file)"/>



    <xsl:template match="/" name="xsl:initial-template">
        

        <xsl:copy-of select="json-to-xml($json-text)"/>
    </xsl:template>
</xsl:stylesheet>
