<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:template match="*" mode="process.note.attention">
        <div class="box box--attention">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="*" mode="process.note.tip">
        <div class="box box--tip">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="*" mode="process.note.remember">
        <div class="box box--remember">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="*" mode="process.note.important">
        <div class="box box--info">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="*" mode="process.note">
        <xsl:choose>
            <xsl:when test="@othertype">
                <div class="box box--note box--{@othertype}">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="box box--note">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
</xsl:stylesheet>
