<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    exclude-result-prefixes="xs math ditaarch " version="3.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@navtitle | @class | @ditaarch:DITAArchVersion | @domains"/>


    <xsl:template match="topichead[@navtitle]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, 'map/topicmeta ')]">
                    <xsl:apply-templates select="*" mode="add-navtitle">
                        <xsl:with-param name="navtitle" select="@navtitle"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <topicmeta>
                        <navtitle>
                            <xsl:value-of select="@navtitle"/>
                        </navtitle>
                    </topicmeta>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topicmeta" mode="add-navtitle">
        <xsl:param name="navtitle"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <navtitle>
                <xsl:value-of select="$navtitle"/>
            </navtitle>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
