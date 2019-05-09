<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- 
            definování hodnoty proměnné
            hodnotu nelze měnit, 
            uvedením proměnné se dosadí její hodnota
    -->
    <xsl:variable name="skoba" select="'⦌'"/>
    
    <!-- 
            hlavička dokumentu se ze zpracování vynechá
            (viz prázdný element šablony)
    -->
    <xsl:template match="tei:teiHeader" />
    
    <!--
        titul edice definovaný na titulní stránce
        zobrazí se nadpisem <h3>
    -->
    <xsl:template match="tei:docTitle">
        <h3><xsl:apply-templates /></h3>
    </xsl:template>
    
    <!-- šablona pro zpracování hlavního textu -->
    <xsl:template match="tei:body">
        <div>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <!-- 
        šablona pro zpracování odstavce
        musí se převést na element <p> z jmenného prostotu HTML
    -->
    <xsl:template match="tei:p">
        <p><xsl:apply-templates /></p>
    </xsl:template>
    
    <!--
        šablona pro volbu mezi variantami
        následujícíc text se oddělí z obou stran mezerami a 
        obklopí počáteční a koncovou značkou
    -->
    <xsl:template match="tei:choice">
        <xsl:text> ⌈</xsl:text><xsl:apply-templates /><xsl:text>⌉ </xsl:text>
    </xsl:template>
    
    
    <!--
        šablona pro chybné znění originálu
        aplikují se další šablony
        pokud obsahuje pouze text, text se objeví na výstupu
    -->
    <xsl:template match="tei:sic">
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- 
        šablona pro opravené znění
        opravený text se vypíše kurzivou (<i>) a od následujícího textu 
        se oddělí skobou a mezerami
    -->
    <xsl:template match="tei:corr">
        
        <i><xsl:apply-templates /></i>
        <!-- vložení skoby pomocí proměnné -->
        <xsl:value-of select="concat(' ', $skoba)"/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <!--
        šablona pro transkribované znění
        text se vypíše tučným písmem (<b>) a od následujícího textu 
        se oddělí speciálním znakem mezerami
    -->
    <xsl:template match="tei:reg">
        <b><xsl:apply-templates /></b><xsl:text> ≈ </xsl:text>
    </xsl:template>
    
     <!--
        šablona pro znění originálu
        aplikují se další šablony
        pokud obsahuje pouze text, text se objeví na výstupu
    -->
    <xsl:template match="tei:orig">
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- 
        šablona pro zpracování poznámky
        při normálním zpracování vloží číslo poznámky v horním indexu (<sup>)
        nevloží samotný obsah
    -->
    <xsl:template match="tei:note">
        <sup><xsl:value-of select="@n"/></sup>
    </xsl:template>
    
    <!-- 
        šablona pro zpracování poznámky na konci dokumentu
        při zpracování vloží číslo poznámky v horním indexu (<sup>)
        a následně její text
    -->
    <xsl:template match="tei:note" mode="notes">
        <p><sup><xsl:value-of select="@n"/></sup><xsl:text> </xsl:text><xsl:apply-templates /></p>
        <xsl:value-of select="tei:div[@type='preface']"/>
    </xsl:template>
    
</xsl:stylesheet>