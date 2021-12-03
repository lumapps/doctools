<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/2005/xpath-functions"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:json="http://lionelmoi.org/functions/json" xmlns:f="http://lionelmoi.org/functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="xs math json f dita-ot " version="3.0">
    <xsl:import href="../xsl/functions.xsl"/>
    <!-- for debug 
    <xsl:output method="xml" indent="yes"/> -->

    <xsl:output method="xml" indent="yes" name="xml"/>
    <xsl:output method="text" indent="yes"/>
    <xsl:mode on-no-match="shallow-skip"/>
    <xsl:mode name="xml-json" on-no-match="deep-skip"/>
    <xsl:mode name="not-metadata" on-no-match="deep-skip"/>
    <xsl:mode name="metadata" on-no-match="deep-skip"/>

    <xsl:variable name="not-metadata" as="xs:string+" select="'template', 'visible_by', 'slug'"/>



    <xsl:template match="*[contains(@class, ' map/map ')]">


        <!--for debug-->


        <xsl:variable name="xml-json">
            <xsl:apply-templates mode="xml-json" select="."/>
        </xsl:variable>

        <!-- for debugging purposes -->
        <xsl:result-document href="ditaMap.xml" format="xml">
            <xsl:copy-of select="$xml-json"/>
        </xsl:result-document>

        <!-- actual json output -->
        <xsl:copy-of select="xml-to-json($xml-json)"/>

    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="xml-json">
        <map>
            <xsl:copy-of select="json:string('title', title)"/>
            <xsl:copy-of select="json:string('language', @xml:lang)"/>
            <map key="map">
                <xsl:apply-templates
                    select="descendant::*[contains(@class, 'map/topicref')][not(ancestor-or-self::*/@processing-role) and not(ancestor-or-self::*/@processing-role = 'resource-only')]"
                    mode="xml-json"/>
            </map>
        </map>
    </xsl:template>


    <!-- create one map per topicref -->
    <xsl:template
        match="*[contains(@class, 'map/topicref')][not(ancestor::*/@chunk = 'to-content') and not(ancestor::*[contains(@class, ' map/reltable ')])]"
        mode="xml-json">

        <map>

            <xsl:attribute name="key">

                <xsl:call-template name="getIdFromTopic"/>

            </xsl:attribute>

            <xsl:if test="not(ancestor::*[contains(@class, 'map/topicref')])">
                <xsl:copy-of select="json:string('root', 'true')"/>
            </xsl:if>

            <xsl:copy-of select="json:string('title', f:get-navtitle(.))"/>

            <xsl:if test="@href | @copy-to">

                <xsl:variable name="path">
                    <xsl:variable name="full-path"
                        select="replace(f:getActualPath(.), '\.dita', '.html') => replace('\.md', '.html')"/>
                    <xsl:value-of select="
                            if (contains($full-path, '#')) then
                                substring-before($full-path, '#')
                            else
                                $full-path"/>
                </xsl:variable>

                <!-- create the path entry -->
                <xsl:copy-of select="json:string('path', $path)"/>

                <xsl:call-template name="get-template">
                    <xsl:with-param name="actualPath" select="f:getActualPath(.)"/>
                </xsl:call-template>

                <xsl:call-template name="getVisibleBy"/>

                <!-- get metadata -->
                <array key="metadata">
                    <xsl:apply-templates
                        select="*[contains(@class, 'map/topicmeta')]/*[contains(@class, 'topic/othermeta')][not($not-metadata = @name)]"
                        mode="metadata"/>
                </array>

            </xsl:if>

            <!-- get parent slug -->
            <xsl:if test="parent::*[contains(@class, 'map/topicref')]">
                <xsl:variable name="id" as="xs:string">
                    <xsl:call-template name="getIdFromTopic">
                        <xsl:with-param name="topicref"
                            select="parent::*[contains(@class, 'map/topicref')]" as="element()"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:copy-of select="json:string('parent', $id)"/>
            </xsl:if>
        </map>
    </xsl:template>

    <xsl:template name="getIdFromTopic">
        <xsl:param name="topicref" as="element()" select="."/>
        <xsl:variable name="href" as="attribute(href)" select="$topicref/@href"/>

        <xsl:variable name="reusedId" as="xs:string?">

            <xsl:choose>
                <xsl:when test="$topicref/ancestor-or-self::*[@keyscope]">
                    <xsl:value-of select="
                            for $i in $topicref/ancestor-or-self::*[@keyscope]
                            return
                                $i/@keyscope"/>
                </xsl:when>
                <xsl:when test="$topicref/@id">
                    <xsl:value-of select="$topicref/@id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <xsl:value-of
            select="f:slugify(/map/@id || '-' || dita-ot:retrieve-href-target($href)/descendant-or-self::*[1][contains(@class, 'topic/topic')]/@id) || replace($reusedId,' ','-')"
        />
    </xsl:template>


    <xsl:template match="*[contains(@class, 'topic/othermeta')]" mode="metadata">
        <map>
            <xsl:copy-of select="json:string('category', @name)"/>
            <xsl:copy-of select="json:string('value', @content)"/>
        </map>
    </xsl:template>
    <xsl:template match="*[contains(@class, 'topic/othermeta')][@name = 'visible_by']"
        mode="not-metadata">
        <string>
            <xsl:value-of select="@content"/>
        </string>
    </xsl:template>
    <xsl:template match="*[contains(@class, 'topic/othermeta')][@name = 'template']"
        mode="not-metadata">
        <xsl:copy-of select="json:string(@name, @content)"/>
    </xsl:template>


    <!-- convenience templates -->
    <xsl:template name="getVisibleBy">
        <xsl:choose>
            <!-- topicref has specific visible_by -->
            <xsl:when
                test="*[contains(@class, 'map/topicmeta')]/descendant-or-self::*[contains(@class, 'topic/othermeta')][@name = 'visible_by']">
                <array key="visible_by">
                    <xsl:for-each-group
                        select="*[contains(@class, 'map/topicmeta')]/descendant-or-self::*[contains(@class, 'topic/othermeta')][@name = 'visible_by']"
                        group-by="@content">
                        <xsl:apply-templates select="." mode="not-metadata"/>
                    </xsl:for-each-group>
                </array>
            </xsl:when>
            <!-- otherwise get map visible_by -->
            <xsl:otherwise>
                <array key="visible_by">
                    <xsl:for-each-group
                        select="/map/*[contains(@class, 'map/topicmeta')]/descendant-or-self::*[contains(@class, 'topic/othermeta')][@name = 'visible_by']"
                        group-by="@content">
                        <xsl:apply-templates select="." mode="not-metadata"/>
                    </xsl:for-each-group>
                </array>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-template">
        <xsl:param name="actualPath" as="xs:string?"/>
        <xsl:if
            test="not(*[contains(@class, 'map/topicmeta')]/*[contains(@class, 'topic/othermeta')]/@name = 'template')"
            > </xsl:if>
        <!-- get template  -->
        <xsl:choose>
            <!-- topicref has specific template -->
            <xsl:when
                test="*[contains(@class, 'map/topicmeta')]/descendant::*[contains(@class, 'topic/othermeta')][@name = 'template']">
                <xsl:apply-templates
                    select="*[contains(@class, 'map/topicmeta')]/descendant::*[contains(@class, 'topic/othermeta')][@name = 'template']"
                    mode="not-metadata"/>
            </xsl:when>
            <!-- otherwise get map template -->
            <xsl:otherwise>
                <xsl:apply-templates
                    select="/map/*[contains(@class, 'map/topicmeta')]/descendant::*[contains(@class, 'topic/othermeta')][@name = 'template']"
                    mode="not-metadata"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="f:getActualPath" as="xs:string?">
        <xsl:param name="context" as="node()"/>
        <xsl:value-of select="
                if ($context/@copy-to) then
                    $context/@copy-to
                else
                    $context/@href"/>
    </xsl:function>

</xsl:stylesheet>
