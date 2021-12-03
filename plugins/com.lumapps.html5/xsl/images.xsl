<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    exclude-result-prefixes="xs math dita-ot dita2html ditamsg" version="3.0">
    
    <xsl:template name="topic-image">
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <img>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class">
                    <xsl:if test="@placement = 'break'"><!--Align only works for break-->
                        <xsl:choose>
                            <xsl:when test="@align = 'left'">imageleft</xsl:when>
                            <xsl:when test="@align = 'right'">imageright</xsl:when>
                            <xsl:when test="@align = 'center'">imagecenter</xsl:when>
                        </xsl:choose>                        
                    </xsl:if>
                    
                    <xsl:if test="@placement = 'inline'"><!-- added for lumapps compatibility purposes -->
                        <xsl:text>fr-dii</xsl:text>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="setid"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
                    <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@longdescref"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@href|@height|@width"/>
            <xsl:apply-templates select="@scale"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/alt ')]">
                    <xsl:variable name="alt-content"><xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/></xsl:variable>
                    <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
                </xsl:when>
                <xsl:when test="@alt">
                    <xsl:attribute name="alt" select="@alt"/>
                </xsl:when>
            </xsl:choose>
        </img>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/image ')]" name="topic.image">
        <!-- build any pre break indicated by style -->
        <xsl:choose>
            <xsl:when test="parent::*[contains(@class, ' topic/fig ')][contains(@frame, 'top ')]">
                <!-- NOP if there is already a break implied by a parent property -->
            </xsl:when>
            <!--<xsl:when test="@placement = 'break'">
                <br/>
            </xsl:when>-->
        </xsl:choose>
        <xsl:call-template name="setaname"/>
        <xsl:choose>
            <xsl:when test="@placement = 'break'"><!--Align only works for break-->
                <xsl:choose>
                    <xsl:when test="@align = 'left'">
                        <div class="imageleft">
                            <xsl:call-template name="topic-image"/>
                        </div>
                    </xsl:when>
                    <xsl:when test="@align = 'right'">
                        <div class="imageright">
                            <xsl:call-template name="topic-image"/>
                        </div>
                    </xsl:when>
                    <xsl:when test="@align = 'center'">
                        <div class="imagecenter">
                            <xsl:call-template name="topic-image"/>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="topic-image"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="topic-image"/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- image name for review -->
        <xsl:if test="$ARTLBL = 'yes'"> [<xsl:value-of select="@href"/>] </xsl:if>
    </xsl:template>


</xsl:stylesheet>
