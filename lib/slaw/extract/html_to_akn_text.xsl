<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="text" indent="no" omit-xml-declaration="yes" encoding="utf-8" />
  <xsl:strip-space elements="*"/>

  <xsl:template match="html">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="head|style|script|link" />

  <xsl:template match="p|div">
    <xsl:choose>
      <xsl:when test="starts-with(., '[') and substring(., string-length(.)) = ']'">
        <!-- block elems that are wrapped in [ and ] are probably remarks -->
        <xsl:text>[</xsl:text><xsl:apply-templates /><xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
    <!-- p and div tags must end with a newline -->
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="table">
    <xsl:text>{| </xsl:text>
    <xsl:text>
|-</xsl:text>
    <xsl:apply-templates />
    <xsl:text>
|}

</xsl:text>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:apply-templates />
    <xsl:text>
|-</xsl:text>
  </xsl:template>

  <xsl:template match="th|td">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'th'">
        <xsl:text>
! </xsl:text>
      </xsl:when>
      <xsl:when test="local-name(.) = 'td'">
        <xsl:text>
| </xsl:text>
      </xsl:when>
    </xsl:choose>

    <!-- attributes -->
    <xsl:if test="@rowspan|@colspan">
      <xsl:for-each select="@rowspan|@colspan">
        <xsl:value-of select="local-name(.)" />
        <xsl:text>="</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>" </xsl:text>
      </xsl:for-each>
      <xsl:text>| </xsl:text>
    </xsl:if>

    <xsl:apply-templates />
  </xsl:template>

  <!-- don't end p tags with newlines in tables -->
  <xsl:template match="table//p">
    <xsl:apply-templates />
  </xsl:template>

  <!-- END tables -->

  <xsl:template match="a[href]">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@href" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="img">
    <xsl:text>![</xsl:text>
    <xsl:value-of select="@alt" />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@src" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="br">
    <xsl:text>
</xsl:text>
  </xsl:template>


  <!-- for most nodes, just dump their text content -->
  <xsl:template match="*">
    <xsl:text/><xsl:apply-templates /><xsl:text/>
  </xsl:template>
  
</xsl:stylesheet>
