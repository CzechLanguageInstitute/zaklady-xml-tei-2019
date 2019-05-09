<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xd tei"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 7, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="priklady">
        <body>
            <xsl:apply-templates />    
        </body>
    </xsl:template>
    
    <xsl:template match="priklad">
        <div n="{@n}">
            <head><xsl:value-of select="@popis"/></head>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>