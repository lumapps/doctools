<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/2005/xpath-functions"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:json="http://lionelmoi.org/functions/json"
    xmlns:f="http://lionelmoi.org/functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="xs math json f dita-ot"
    version="3.0">

    <xsl:import
        href="plugin:org.dita.base:xsl/common/functions.xsl"/>
    <xsl:import
        href="plugin:org.dita.base:xsl/common/uri-utils.xsl"/>
    <xsl:import
        href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
    <xsl:import
        href="plugin:org.dita.base:xsl/common/output-message.xsl"/>

    <xsl:mode
        name="slug"
        on-no-match="deep-skip"/>

    <xsl:function
        name="f:getExt"
        as="xs:string">
        <xsl:param
            name="i"
            as="attribute(href)"/>
        <xsl:variable
            name="tokenized"
            select="tokenize($i, '.')"/>
        <xsl:value-of
            select="$tokenized[count($tokenized)]"/>
    </xsl:function>

    <xsl:function
        name="f:getFilename"
        as="xs:string">
        <xsl:param
            name="i"
            as="attribute(href)"/>

        <xsl:variable
            name="ext"
            select="f:getExt($i)"/>
        <xsl:variable
            name="tokenized-slash"
            select="substring-before($i, '.' || $ext) => tokenize('/')"/>

        <xsl:variable
            name="dvrSuffix"
            select="$i/ancestor::*/ditavalref/descendant::dvrResourceSuffix"
            as="xs:string?"/>

        <xsl:value-of
            select="$tokenized-slash[count($tokenized-slash)] || $dvrSuffix"/>

    </xsl:function>

    <xsl:function
        name="f:generateSlug"
        as="xs:string">
        <xsl:param
            name="topicref"
            as="element()"/>
        <xsl:param
            name="map"
            as="element(map)"/>
        <xsl:variable
            name="href"
            as="attribute(href)">
            <xsl:attribute
                name="href"
                select="$topicref/@href"/>
        </xsl:variable>

        <xsl:message
            select="'-------------------------------------------------------'"/>
        <xsl:message
            select="'href: ' || $href"/>


        

    </xsl:function>



    <!-- create a json string xml representation with a specific key -->
    <xsl:function
        name="json:string"
        as="element(string)"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param
            name="key"
            as="xs:string"/>
        <xsl:param
            name="string"
            as="xs:string"/>
        <string
            key="{$key}">
            <xsl:value-of
                select="$string"/>
        </string>
    </xsl:function>

    <!-- create a json string xml representation using the element name as key -->
    <xsl:function
        name="json:string"
        as="element(string)"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param
            name="element"
            as="element()"/>
        <string
            key="{local-name($element)}">
            <xsl:value-of
                select="string-join($element/descendant-or-self::text())"/>
        </string>
    </xsl:function>

    <xsl:function
        name="f:get-navtitle"
        as="xs:string">
        <xsl:param
            name="topicref"
            as="element()"/>
        <xsl:value-of
            select="$topicref/*[contains(@class, 'map/topicmeta')]/*[contains(@class, 'topic/navtitle')]/descendant-or-self::*/text()"/>
    </xsl:function>

    <xsl:function
        name="f:slugify"
        as="xs:string">
        <xsl:param
            name="text"/>
        <xsl:variable
            name="dodgyChars"
            select="' ,.#_-!?*:;=+|&amp;/\\'"/>
        <xsl:variable
            name="replacementChar"
            select="'-----------------'"/>
        <xsl:variable
            name="lowercase"
            select="'abcdefghijklmnopqrstuvwxyz'"/>
        <xsl:variable
            name="uppercase"
            select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
        <xsl:variable
            name="lowercased">
            <xsl:value-of
                select="translate($text, $uppercase, $lowercase)"/>
        </xsl:variable>
        <xsl:variable
            name="escaped">
            <xsl:value-of
                select="translate($lowercased, $dodgyChars, $replacementChar) => lower-case()"/>
        </xsl:variable>
        <xsl:value-of
            select="$escaped"/>
    </xsl:function>

</xsl:stylesheet>
