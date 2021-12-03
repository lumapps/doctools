<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <pattern>
        <rule context="*[contains(@class, ' topic/topic')]">
            <assert
                test="matches(@id, 'l\d+') or ends-with(@id, 'landing') or contains(@id, 'reuse_') or @id = 'warnings' or @id = 'who_can_use' or @id = 'tables'"
                sqf:fix="addId"> The id "<value-of select="@id"/>" does not follow the right
                pattern. </assert>
            <sqf:fix id="addId">
                <sqf:description>
                    <sqf:title>Correct @id pattern</sqf:title>
                </sqf:description>
                <sqf:replace match="@id" node-type="attribute" target="id"
                    select="'l' || substring-after(xs:string(random-number-generator()?number), '0.')"
                />
            </sqf:fix>
        </rule>
    </pattern>
</schema>
