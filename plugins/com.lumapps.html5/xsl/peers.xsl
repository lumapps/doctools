<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:topicpull="http://dita-ot.sourceforge.net/ns/200704/topicpull" xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dita-ot topicpull ditamsg xs">

    <xsl:function name="dita-ot:getTargetDoc" as="document-node()?">
        <xsl:param name="linkElement" as="element()"/>
        <xsl:param name="baseContextElement" as="element()?"/>

        <xsl:variable name="targetURI" as="xs:string?" select="$linkElement/@href"/>
        <xsl:choose>
            <xsl:when test="normalize-space($targetURI) = ''">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="resourcePart" as="xs:string?" select="tokenize($targetURI, '#')[1]"/>
                <xsl:variable name="scope" select="dita-ot:get-link-scope($linkElement, 'local')" as="xs:string"/>
                <xsl:variable name="format" select="dita-ot:get-link-format($linkElement, 'dita')" as="xs:string"/>
                <xsl:choose>
                    <xsl:when test="$scope = ('peer')">
                        <xsl:sequence select="()"/>
                        <xsl:message select="'I am a peer!'"/>
                        <xsl:message select="'$linkElement'"/>
                        <xsl:message>
                            <xsl:copy-of select="$linkElement"/>
                        </xsl:message>
                    </xsl:when>
                    <xsl:when test="not($scope = ('local'))">
                        <!-- Not a local-scope link, don't resolve it.
              
                 FIXME: For peer-scope references may need to actually do resolution
                        for cross-deliverable link key references. Not sure how that
                        is being handled in preprocessing.
              -->
                        <xsl:sequence select="()"/>
                    </xsl:when>
                    <xsl:when test="not($format = ('dita', 'ditamap'))">
                        <!-- Local scope but not a dita or ditamap target, cannot resolve. -->
                        <xsl:sequence select="()"/>
                    </xsl:when>
                    <xsl:when test="empty($resourcePart)">
                        <xsl:sequence select="root($linkElement)"/>
                    </xsl:when>
                    <xsl:otherwise>

                        <xsl:variable name="targetDoc" as="document-node()?"
                            select="
                                document($resourcePart, if (exists($baseContextElement)) then
                                    $baseContextElement
                                else
                                    $linkElement)"/>
                        <xsl:choose>
                            <xsl:when test="empty($targetDoc)">
                                <!-- Report the failure to resolve the URI -->
                                <xsl:apply-templates select="$linkElement" mode="ditamsg:missing-href-target">
                                    <xsl:with-param name="file" select="$targetURI"/>
                                </xsl:apply-templates>
                                <xsl:sequence select="()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="$targetDoc"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
