<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd f"
    xmlns:f="http://www.lionel.org/functions" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 26, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> lionel.moizeau</xd:p>
            <xd:p>This stylesheet contains all DITA outputs used for generated DITA documents.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p>DITA topic 1.2</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA Topic//EN"
        name="ditaDTDtopic" doctype-system="topic.dtd" omit-xml-declaration="no" indent="yes"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>DITA topic 1.3</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA 1.3 Topic//EN"
        name="ditaDTDtopic13" doctype-system="topic.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA reference 1.2</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA Reference//EN"
        name="ditaDTDref" doctype-system="reference.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA concept 1.2</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA Concept//EN"
        name="ditaDTDconcept" doctype-system="concept.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA task 1.2</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA Task//EN"
        name="ditaDTDtask" doctype-system="task.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA subjectScheme</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA Subject Scheme Map//EN" name="ditaDTDsubjectScheme"
        doctype-system="subjectScheme.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA Map//EN"
        name="ditaDTDmap" doctype-system="map.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA 1.3 Reference//EN"
        name="ditaDTDref13" doctype-system="reference.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA 1.3 Concept//EN"
        name="ditaDTDconcept13" doctype-system="concept.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA task 1.3</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA 1.3 Task//EN"
        name="ditaDTDtask13" doctype-system="task.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA subjectScheme 1.3</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8"
        doctype-public="-//OASIS//DTD DITA 1.3 Subject Scheme Map//EN" name="ditaDTDsubjectScheme13"
        doctype-system="subjectScheme.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITA map 1.3</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA 1.3 Map//EN"
        name="ditaDTDmap13" doctype-system="map.dtd" omit-xml-declaration="no" indent="yes"/>

    <xd:doc>
        <xd:desc>
            <xd:p>DITAVAL</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes" name="ditaval"/>

</xsl:stylesheet>
