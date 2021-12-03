<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" version="3.0" exclude-result-prefixes="xs dita-ot dita2html ditamsg">

    <!-- 
        Modifying shortdesc processing to get the shortdesc of the top topic out of the body div. 
        Only applies to topics that are not nested.
    -->

    <xsl:template match="*[contains(@class, ' topic/body ')][not(count(ancestor::*[contains(@class, ' topic/topic ')]) > 1)]" name="topic.body">
        <!-- get the shortdesc para -->
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/shortdesc ')]" mode="main-shortdesc"/>

        <div>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <!-- here, you can generate a toc based on what's a child of body -->
            <!--xsl:call-template name="gen-sect-ptoc"/-->
            <!-- Works; not always wanted, though; could add a param to enable it.-->

            <!-- Insert prev/next links. since they need to be scoped by who they're 'pooled' with, apply-templates in 'hierarchylink' mode to linkpools (or related-links itself) when they have children that have any of the following characteristics:
         - role=ancestor (used for breadcrumb)
         - role=next or role=previous (used for left-arrow and right-arrow before the breadcrumb)
         - importance=required AND no role, or role=sibling or role=friend or role=previous or role=cousin (to generate prerequisite links)
         - we can't just assume that links with importance=required are prerequisites, since a topic with eg role='next' might be required, while at the same time by definition not a prerequisite -->

            <!-- Added for DITA 1.1 "Shortdesc proposal" -->
            <!-- get the abstract para -->
            <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/abstract ')]" mode="outofline"/>



            <!-- Insert pre-req links - after shortdesc - unless there is a prereq section about -->
            <xsl:apply-templates select="following-sibling::*[contains(@class, ' topic/related-links ')]" mode="prereqs"/>

            <xsl:apply-templates/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
        </div>
    </xsl:template>


    <!-- task specific bullshit -->

    <xsl:template match="*[contains(@class, ' task/taskbody ')][not(count(ancestor::*[contains(@class, ' topic/topic ')]) > 1)]"
        name="topic.task.taskbody" priority="5">
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/shortdesc ')]" mode="main-shortdesc"/>
        <div>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <!-- here, you can generate a toc based on what's a child of body -->
            <!--xsl:call-template name="gen-sect-ptoc"/-->
            <!-- Works; not always wanted, though; could add a param to enable it.-->

            <!-- Added for DITA 1.1 "Shortdesc proposal" -->
            <!-- get the abstract para -->
            <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' topic/abstract ')]" mode="outofline"/>

            <!-- get the short descr para -->


            <!-- Insert pre-req links here, after shortdesc - unless there is a prereq section about -->
            <xsl:if test="not(*[contains(@class, ' task/prereq ')])">
                <xsl:apply-templates select="following-sibling::*[contains(@class, ' topic/related-links ')]" mode="prereqs"/>
            </xsl:if>

            <xsl:apply-templates/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
        </div>
    </xsl:template>

    <!-- called shortdesc processing - para at start of topic -->
    <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="main-shortdesc">
        <div xsl:use-attribute-sets="shortdesc">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/shortdesc ')][not(count(ancestor::*[contains(@class, ' topic/topic ')]) > 1)][not(following-sibling::*[contains(@class,' topic/body ')])]">
        <xsl:apply-templates select="." mode="main-shortdesc"/>
        <xsl:apply-templates select="following-sibling::*[contains(@class, ' topic/related-links ')]" mode="prereqs"/>
    </xsl:template>

</xsl:stylesheet>
