<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">

    <xsl:template match="*" mode="gen-user-sidetoc">
        <xsl:if test="$nav-toc = ('partial', 'full') and $current-topicref[@chunk]">
            <nav xsl:use-attribute-sets="toc">
                <ul>
                    <xsl:choose>
                        <xsl:when test="$nav-toc = 'partial'">
                            <xsl:apply-templates select="$current-topicref/*[contains(@class, ' map/topicref ')]" mode="toc">
                                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                            </xsl:apply-templates>

                            

                        </xsl:when>
                        <xsl:when test="$nav-toc = 'full'">
                            <xsl:apply-templates select="$input.map" mode="toc">
                                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </ul>
            </nav>
        </xsl:if>
    </xsl:template>
    
    

</xsl:stylesheet>
