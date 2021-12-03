<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:json="http://lionelmoi.org/functions/json" xmlns:f="http://lionelmoi.org/functions" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math json f" version="3.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:import href="../plugins/com.lumapps.mapJson/xsl/functions.xsl"/>

    <xsl:output method="xml" indent="yes"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="/">

        <xsl:apply-templates select="node()"/>

    </xsl:template>

    <xsl:template
        match="
            topicref
            [not(ancestor-or-self::*/@processing-role)]
            [not(ancestor::*/@chunk)]
            [not(topicmeta)]
            [not(@format) or @format = 'dita']
            ">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <topicmeta>
                <xsl:apply-templates select="." mode="resourceid"/>
            </topicmeta>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>

    </xsl:template>

    <xsl:template match="topicref
        [not(ancestor-or-self::*/@processing-role)]
        [not(ancestor::*/@chunk)]
        [not(@format) or @format = 'dita']
        /topicmeta">
        <xsl:copy>
            <!-- copy content -->
            <xsl:apply-templates select="node() | @*"/>
            <xsl:apply-templates select="parent::*" mode="resourceid"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="topicref" mode="resourceid">
        <!-- add resourceId -->

        <xsl:variable name="slug-root" select="f:generateSlug(.,/map)"/>

        <xsl:variable name="slug" as="xs:string+"
            select="
                if (@href | @copy-to) then
                    string-join(reverse(for $i in ancestor-or-self::*[ditavalref/descendant::dvrResourceSuffix]
                    return
                        $i/ditavalref/descendant::dvrResourceSuffix)) => f:slugify()
                else
                    ''"/>

        <xsl:if test="not(topicmeta/resourceid)">
            <resourceid conkeyref="resourceids/{$slug-root  ||  $slug }"/>
        </xsl:if>
    </xsl:template>

    

</xsl:stylesheet>
