<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">

    <!-- docWidget classes are used by the lumapps-dita script to map elements of the resulting html with widgets in the specified template -->
    <xsl:attribute-set name="toc">
        <xsl:attribute name="class">docWidget docWidget-pagenav</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>
