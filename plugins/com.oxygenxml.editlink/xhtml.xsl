<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:editlink="http://oxygenxml.com/xslt/editlink/" exclude-result-prefixes="xs editlink" version="2.0">

  <xsl:import href="link.xsl"/>

  <xsl:param name="editlink.remote.ditamap.url"/>
  <xsl:param name="editlink.web.author.url"/>
  <xsl:param name="editlink.present.only.path.to.topic"/>
  <xsl:param name="editlink.local.ditamap.path"/>
  <xsl:param name="editlink.local.ditaval.path"/>

  <!-- Override the topic/title processing to add 'Edit Link' action. -->
  <xsl:template
    match="
      *[contains(@class, ' topic/topic ')]
      [not(ancestor::*[contains(@class, ' topic/topic ')])]
      /*[contains(@class, ' topic/title ')][@xtrf]">
    
    <xsl:choose>
      <xsl:when test="
          string-length($editlink.remote.ditamap.url) > 0
          or $editlink.present.only.path.to.topic = 'true'">
        <!-- Get the default output in a temporary variable -->
        <xsl:variable name="topicTitleFragment"> </xsl:variable>
        <div class="docWidget docWidget-editlink">
          <ul>
            <xsl:apply-templates select="parent::*[contains(@class, ' topic/topic ')]/descendant-or-self::*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')][@xtrf]"
              mode="add-edit-link"/>
          </ul>
        </div>
        <xsl:next-match/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Add a span element associated with the 'Edit Link' action -->
  <xsl:template match="*[contains(@class, ' topic/title ')][@xtrf]" mode="add-edit-link" priority="5">
    <xsl:variable name="html-title">
      <xsl:next-match/>
    </xsl:variable>
    <li>
      <a target="_blank"
        href="{editlink:compute($editlink.remote.ditamap.url, $editlink.local.ditamap.path, @xtrf, $editlink.web.author.url, $editlink.local.ditaval.path)}"
        ><span><xsl:text>Review and edit </xsl:text><b><xsl:value-of select="$html-title/*"/></b> source.</span></a>
    </li>

  </xsl:template>

  <xsl:template match="node() | @*" mode="add-edit-link">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
