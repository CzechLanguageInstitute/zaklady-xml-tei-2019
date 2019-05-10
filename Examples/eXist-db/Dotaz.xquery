xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $collection := collection("/db/apps/zaklady-xml-tei2/")
return $collection//tei:choice

