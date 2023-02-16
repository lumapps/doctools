<?xml version="1.0" encoding="UTF-8" ?>
<!--
This file is part of the DITA Open Toolkit project.

Copyright 2004, 2005 IBM Corporation

See the accompanying LICENSE file for applicable license.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="*[contains(@class, ' ui-d/uicontrol ')]" name="topic.ui-d.uicontrol">
        <!-- insert an arrow with leading/trailing spaces before all but the first uicontrol in a menucascade -->
        <xsl:if test="ancestor::*[contains(@class, ' ui-d/menucascade ')]">
            <xsl:variable name="uicontrolcount">
                <xsl:number count="*[contains(@class, ' ui-d/uicontrol ')]"/>
            </xsl:variable>
            <xsl:if test="$uicontrolcount &gt; '1'">
                <xsl:variable name="a11y.text" as="text()?">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'a11y.and-then'"/>
                    </xsl:call-template>
                </xsl:variable>
                <abbr>
                    <xsl:if test="exists($a11y.text)">
                        <xsl:attribute name="title" select="$a11y.text"/>
                    </xsl:if>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'#menucascade-separator'"/>
                    </xsl:call-template>
                </abbr>
            </xsl:if>
        </xsl:if>
        <span class="uicontrol">
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'uicontrol'"/> 
            </xsl:call-template>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>


</xsl:stylesheet>
