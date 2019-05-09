<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8" />
    
    <!-- Transformace, která doplní odpovědnost k jenotlivýcn poznámkám -->
    
    <xsl:template match="/">
        <xsl:comment> Komentář na začátku dokumentu </xsl:comment>
        <xsl:apply-templates />
    </xsl:template>
    
    <!--
        přepsání vestavěných šablon
        uzly a atributy se budou do výstupu kopírovat jako uzly a atributy
    -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <!--
        šablona pro prázdný oddíl
        element <p> neobsahuje žádný uzel
    -->
    <xsl:template match="tei:div[tei:p[not(node())]]" />
    
    <!--
        šablona pro odpovědnou osobu,
        konkrétně editora
    -->
    <xsl:template match="tei:respStmt[tei:resp[. = 'editor']]">

        <!-- vygenerjuje identifikátor pro editora (z iniciál)        -->
        <xsl:variable name="id">
            <xsl:call-template name="get-editor-id">
                <xsl:with-param name="editor" select="." />
            </xsl:call-template>
        </xsl:variable>
        
        <!-- zkopíruje původní element -->
        <xsl:copy>
            <!-- zkopíruje všechny atributy elementu -->
            <xsl:copy-of select="@*" />
            <!-- vytvoří nový atribut @xml:id s vygenerovým identifikátorem -->
            <xsl:attribute name="id" namespace="http://www.w3.org/XML/1998/namespace">
                <xsl:value-of select="$id"/>
            </xsl:attribute>
            <!-- aplikuje šablony, aby se překopírovaly vořené prvky -->
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <!--
        pojmenovaná šablona
        pro generování identifikátoru editora
        jako parametr vyžaduje element tei:respStmt
    -->
    <xsl:template name="get-editor-id">
        <xsl:param name="editor" />

        <!-- dočasná proměnná sestávající z prvních písmen jména  -->
        <xsl:variable name="first-letters">
            <!-- 
                rozdělí jméno na slova a obrátí jejich pořadí
                jména zapisujeme typem "Hanzová, Barbora"
                takže vznikne sekvence Barbora Hanzová
            -->
            <xsl:for-each select="reverse(tokenize($editor/tei:name, '\W+'))">
                <!-- z každého slova vezme první písmeno -->
                <xsl:value-of select="substring(., 1, 1)"/>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- 
            nakonec pro jistotu odstraní mezeru mezi písmeny
            pokud by tam nějaké byly
            výsledek vrátí na volané místo
        -->
        <xsl:value-of select="translate($first-letters, ' ', '')"/>

    </xsl:template>
    
    <!--
        šablona pro poznámku
        na základě jejího obsahu
        přidá atribut @type
        přidá atribut @resp a nastaví identifikátor editora
    -->
    <xsl:template match="tei:note">
        
        <!--  
            proměnná pro identifikátor editora
            použiju prvního editora, který je uveden v hlavičce
        -->
        <xsl:variable name="id">
            <xsl:call-template name="get-editor-id">
                <xsl:with-param name="editor" select="/tei:TEI//tei:respStmt[tei:resp[. = 'editor']]" />
            </xsl:call-template>
        </xsl:variable>
        
        <!--
            proměnná pro typ poznámky
            na základě obsahu vyberu jeden z typů
        -->
        <xsl:variable name="type">
            <xsl:choose>
                    <xsl:when test="tei:choice[tei:sic]">
                        <xsl:text>error</xsl:text>
                    </xsl:when>
                    <xsl:when test="tei:choice[tei:reg]">
                        <xsl:text>transliteration</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>comment</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        
        <!-- zkopíruje původní element -->
        <xsl:copy>
            <!-- zkopíruje všechny atributy elementu -->
            <xsl:copy-of select="@*" />
            <!-- vytvoří nový atribut @resp -->
            <xsl:attribute name="resp">
                <!-- vloží do atributu hodnotu -->
                <xsl:value-of select="concat('#', $id)"/>
            </xsl:attribute>
            
            <!-- vytvoří nový atribut @type a vloží do něj hodnotu -->
            <xsl:attribute name="type" select="$type" />

            <!-- aplikuje šablony, aby se překopírovaly vořené prvky -->
            <xsl:apply-templates />
            
        </xsl:copy>
    </xsl:template>
  
</xsl:stylesheet>