<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">

    <xsl:attribute-set name="main">
        <xsl:attribute name="class">docWidget docWidget-body</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template match="*" mode="addContentToHtmlBodyElement">
        <main xsl:use-attribute-sets="main">
            <article xsl:use-attribute-sets="article">
                <xsl:attribute name="aria-labelledby">
                    <xsl:apply-templates
                        select="
                            *[contains(@class, ' topic/title ')] |
                            self::dita/*[1]/*[contains(@class, ' topic/title ')]"
                        mode="return-aria-label-id"/>
                </xsl:attribute>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
                <xsl:apply-templates/>
                <!-- this will include all things within topic; therefore, -->
                <!-- title content will appear here by fall-through -->
                <!-- followed by prolog (but no fall-through is permitted for it) -->
                <!-- followed by body content, again by fall-through in document order -->
                <!-- followed by related links -->
                <!-- followed by child topics by fall-through -->
                <xsl:call-template name="gen-endnotes"/>
                <!-- include footnote-endnotes -->
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            </article>
        </main>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/title ')]">
        <xsl:if test="preceding::*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]">
            <xsl:next-match/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
