<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
     <!-- import šablon a dalšího kódu ze samostatného souboru -->
    <xsl:import href="Convert-TEI-to-HTML-Details.xsl"/>
    
    <!-- nastavení parametrů pro výstupní dokument -->
    <xsl:output encoding="UTF-8" indent="yes" method="html" />
    
    <!-- odstranění prázdných mezer u všech elementů  -->
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="tex" select="''" />
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Konverze XML TEI na HTML</title>
                <style>
                    ul { list-style-type: none; }
                </style>
            </head>
            <body>

                <!-- 
                    volání nepojmenovaných šablon
                    
                -->
                <xsl:apply-templates />
                
                <!--
                    volální nepojmenovaných šablon ve speciálním režimu
                    slouží k vypsání samotného textového obsahu poznámek
                    při volání se pomocí @select vybeou pouze elementy pro poznámky
                -->
                <div>
                    <h3>Poznámky pod čarou</h3>
                    <xsl:apply-templates select="//tei:body//tei:note" mode="notes" />
                </div>

                <!-- volání pojmenované šablony -->
                <xsl:call-template name="list-choices" />
                <xsl:call-template name="list-errors" />
                
                <!-- volální pojmenované šablony s paramatry -->
                <xsl:call-template name="list-statistics">
                    <!-- hodnoty se předávají pomocí atributu @select -->
                    <!-- @select obsahuje XPath, hodnotu bude tvořit uzel -->
                    <xsl:with-param name="context" select="//tei:teiHeader" />
                    <!-- @select obsahuje text v jednouchých uvozovkách, honotou bude text -->
                    <xsl:with-param name="element-name" select="'p'" />
                </xsl:call-template>
                
                <xsl:call-template name="list-statistics">
                    <!-- hodnoty se předávají pomocí atributu @select -->
                    <!-- @select obsahuje XPath, hodnotu bude tvořit uzel -->
                    <xsl:with-param name="context" select="//tei:body" />
                    <!-- @select obsahuje text v jednouchých uvozovkách, honotou bude text -->
                    <xsl:with-param name="element-name" select="'p'" />
                </xsl:call-template>
                
                
            </body>
        </html>
    </xsl:template>
    
    <!--
        titul edice definovaný na titulní stránce
        zobrazí se nadpisem <h4> a kurzivou (<i>)
        přepíše šablonu definovaou v ipomrtované souboru
    -->
    <xsl:template match="tei:docTitle">
        <h4><i><xsl:apply-templates /></i></h4>
    </xsl:template>
    
    
    
    
    <!-- 
        pojmenovaná šablona
        projde všechny elemeneny tei:choice, očísluje jejich pořadí a vypíše je
    -->
    <xsl:template name="list-choices">
        <!-- cyklus pro procházení elementů -->
        <h2>Elementy &lt;choice&gt;</h2>
        <ul>
        <xsl:for-each select=".//tei:choice">
            <li><xsl:value-of select="position()"/>.
                <xsl:apply-templates select="." />
            </li>
        </xsl:for-each>
        </ul>
    </xsl:template>
    
    <!--
        pojmenovaná šablona
        projde všechny elemeneny tei:choice, které upozorňují na chybná místa
    -->
    <xsl:template name="list-errors">
        <h2>Písařské chyby</h2>
        <ul>
            <xsl:for-each select=".//tei:choice[tei:sic]">
                <li><xsl:value-of select="position()"/>.
                    <xsl:apply-templates select="." />
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <!--
        pojmenovaná šablona
        vypíše statistiky používaných značek
        definuje proměnnou context, tj. uzel,
        pro nějž se budou statistiky počítat
    -->
    <xsl:template name="list-statistics">
        
        <xsl:param name="context" />
        <xsl:param name="element-name" />
        <!-- pomocí XPath získám názvy elementů, které tvoří dětské prvky -->
        <h2>Statistiky elementu s názvem <i><xsl:value-of select="$element-name"/></i>, výchozí element: <i><xsl:value-of select="$context/name()"/></i></h2>
        <p>Počet bezprostředně podřízených elementů: <xsl:value-of select="count($context/*[local-name() = $element-name])"/></p>
        <p>Počet podřízených elementů: <xsl:value-of select="count($context//*[local-name() = $element-name])"/></p>
        
    </xsl:template>
    
</xsl:stylesheet>