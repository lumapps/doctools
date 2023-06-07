<?xml version="1.0" encoding="UTF-8" ?>
<!--
This file is part of the DITA Open Toolkit project.

Copyright 2004, 2005 IBM Corporation

See the accompanying LICENSE file for applicable license.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- add "codeph" as the default outputclass value for all codeph tags -->

  <xsl:template match="*[contains(@class, ' pr-d/codeph ')]" name="topic.pr-d.codeph">
    <code class="codeph">
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="'codeph'"/>
      </xsl:call-template>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates/>
    </code>
  </xsl:template>

</xsl:stylesheet>
