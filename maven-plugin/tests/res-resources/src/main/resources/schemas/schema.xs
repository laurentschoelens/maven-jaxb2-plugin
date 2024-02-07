<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:jaxb="https://jakarta.ee/xml/ns/jaxb"
	jaxb:version="3.0">

	<xs:annotation>
		<xs:appinfo>
			<jaxb:globalBindings choiceContentProperty="true" generateIsSetMethod="true" generateElementProperty="true" generateElementClass="true">
				<!--xjc:noValidator />
				<xjc:noValidatingUnmarshaller /-->
			</jaxb:globalBindings>
			<jaxb:schemaBindings>
				<jaxb:package name="org.jvnet.jaxb2_commons.tests.two"/>
			</jaxb:schemaBindings>
		</xs:appinfo>
	</xs:annotation>

	<xs:element name="heteroSequence" type="heteroSequenceType"/>
	<xs:complexType name="heteroSequenceType">
		<xs:sequence>
			<xs:element name="sa" type="xs:string"/>
			<xs:element name="sb" type="xs:string"/>
			<xs:sequence>
				<xs:element name="sc" type="xs:string"/>
				<xs:element name="sd" type="xs:string"/>
			</xs:sequence>
			<xs:sequence maxOccurs="unbounded">
				<xs:element name="se" type="xs:string"/>
				<xs:element name="sf" type="sequenceType"/>
			</xs:sequence>
		</xs:sequence>
	</xs:complexType>

	<xs:element name="heteroChoice" type="heteroChoiceType"/>
	<xs:complexType name="heteroChoiceType">
		<xs:choice>
			<xs:element name="ca" type="xs:string"/>
			<xs:element name="cb" type="xs:string"/>
			<xs:choice>
				<xs:element name="cc" type="xs:string"/>
				<xs:element name="cd" type="xs:string"/>
			</xs:choice>
			<xs:choice maxOccurs="unbounded">
				<xs:element name="ce" type="xs:string"/>
				<xs:element name="cf" type="sequenceType"/>
			</xs:choice>
		</xs:choice>
	</xs:complexType>

	<xs:element name="mixed" type="mixedType"/>

	<xs:complexType name="mixedType" mixed="true">
		<xs:sequence>
			<xs:element name="name" type="xs:string"/>
			<xs:element name="orderid" type="xs:positiveInteger"/>
			<xs:element name="shipdate" type="xs:date"/>
		</xs:sequence>
	</xs:complexType>

	<xs:element name="ignoredRoot" type="rootType">
	</xs:element>
	<xs:element name="anotherIgnoredRoot" type="rootType"/>
	<xs:element name="root" type="rootType"/>
	<xs:complexType name="rootType">
		<xs:sequence>
			<xs:element name="sequence" type="sequenceType" minOccurs="0"/>
			<xs:element name="simpleTypes" type="simpleTypesType" minOccurs="0"/>
			<xs:element name="elementWithListAttribute1" type="elementWithListAttribute1" minOccurs="0"/>
			<xs:element name="facet" type="facetType" minOccurs="0"/>
			<xs:element name="ignored" type="xs:string">
			</xs:element>
			<xs:element name="anotherIgnored" type="xs:string"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="sequenceType">
		<xs:sequence>
			<xs:element name="a" type="xs:string" minOccurs="0"/>
			<xs:element name="b" type="xs:long" minOccurs="0"/>
		</xs:sequence>
	</xs:complexType>
	<xs:element name="extendedSequence" type="extendedSequenceType"/>
	<xs:complexType name="extendedSequenceType">
		<xs:complexContent>
		    <xs:extension base="sequenceType">
				<xs:sequence>
					<xs:element name="c" type="xs:dateTime" minOccurs="0"/>
					<xs:element name="d" type="xs:base64Binary" minOccurs="0"/>
				</xs:sequence>
		    </xs:extension>
		</xs:complexContent>
	</xs:complexType>
	<xs:element name="severalSimpleTypes">
		<xs:complexType>
			<xs:sequence>
				<xs:element name="st1" type="simpleTypesType"/>
				<xs:element name="st2" type="simpleTypesType"/>
				<xs:element name="st3" type="simpleTypesType" maxOccurs="unbounded"/>
				<xs:element name="st4" type="simpleTypesType" maxOccurs="unbounded"/>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
	<xs:element name="simpleTypes" type="simpleTypesType"/>
	<xs:complexType name="simpleTypesType">
		<xs:sequence>
			<xs:element name="base64Binary" type="xs:base64Binary" minOccurs="0"/>
			<xs:element name="hexBinary" type="xs:hexBinary" minOccurs="0"/>
			<xs:element name="duration" type="xs:duration" minOccurs="0"/>
			<xs:element name="dateTime" type="xs:dateTime" minOccurs="0"/>
			<xs:element name="date" type="xs:date" minOccurs="0"/>
			<xs:element name="time" type="xs:time" minOccurs="0"/>
			<xs:element name="gYearMonth" type="xs:gYearMonth" minOccurs="0"/>
			<xs:element name="gYear" type="xs:gYear" minOccurs="0"/>
			<xs:element name="gMonthDay" type="xs:gMonthDay" minOccurs="0"/>
			<xs:element name="gDay" type="xs:gDay" minOccurs="0"/>
			<xs:element name="gMonth" type="xs:gMonth" minOccurs="0"/>
			<xs:element name="float" type="xs:float" minOccurs="0"/>
			<xs:element name="double" type="xs:double" minOccurs="0"/>
			<xs:element name="decimal" type="xs:decimal" minOccurs="0"/>
			<xs:element name="integer" type="xs:integer" minOccurs="0"/>
			<xs:element name="long" type="xs:long" minOccurs="0"/>
			<xs:element name="int" type="xs:int" minOccurs="0"/>
			<xs:element name="short" type="xs:short" minOccurs="0"/>
			<xs:element name="byte" type="xs:byte" minOccurs="0"/>
			<xs:element name="unsignedLong" type="xs:unsignedLong" minOccurs="0"/>
			<xs:element name="unsignedInt" type="xs:unsignedInt" minOccurs="0"/>
			<xs:element name="unsignedShort" type="xs:unsignedShort" minOccurs="0"/>
			<xs:element name="unsignedByte" type="xs:unsignedByte" minOccurs="0"/>
			<xs:element name="nonNegativeInteger" type="xs:nonNegativeInteger" minOccurs="0"/>
			<xs:element name="nonPositiveInteger" type="xs:nonPositiveInteger" minOccurs="0"/>
			<xs:element name="positiveInteger" type="xs:positiveInteger" minOccurs="0"/>
			<xs:element name="negativeInteger" type="xs:negativeInteger" minOccurs="0"/>
			<xs:element name="boolean" type="xs:boolean" minOccurs="0"/>
			<xs:element name="anyURI" type="xs:anyURI" minOccurs="0"/>
			<xs:element name="QName" type="xs:QName" minOccurs="0"/>
			<!--xs:element name="NOTATION" type="xs:NOTATION" minOccurs="0"/-->
			<xs:element name="string" type="xs:string" minOccurs="0"/>
			<xs:element name="normalizedString" type="xs:normalizedString" minOccurs="0"/>
			<xs:element name="token" type="xs:token" minOccurs="0"/>
			<xs:element name="language" type="xs:language" minOccurs="0"/>
			<xs:element name="Name" type="xs:Name" minOccurs="0"/>
			<xs:element name="NCName" type="xs:NCName" minOccurs="0"/>
			<xs:element name="ID" type="xs:ID" minOccurs="0"/>
			<!--xs:element name="IDREF" type="xs:IDREF" minOccurs="0"/>
      <xs:element name="IDREFS" type="xs:IDREFS"/-->
			<xs:element name="ENTITY" type="xs:ENTITY" minOccurs="0"/>
			<xs:element name="ENTITIES" type="xs:ENTITIES" minOccurs="0"/>
			<xs:element name="NMTOKEN" type="xs:NMTOKEN" minOccurs="0"/>
			<xs:element name="NMTOKENS" type="xs:NMTOKENS" minOccurs="0"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="elementWithListAttribute1">
		<xs:attribute name="list1" type="listType1" use="optional"/>
	</xs:complexType>
	<xs:simpleType name="listType1">
		<xs:list itemType="patternType1"/>
	</xs:simpleType>
	<xs:simpleType name="patternType1">
		<xs:restriction base="xs:string">
			<xs:length value="9"/>
			<xs:pattern value="[A-Z]{2}([0-9]|[A-Z]){7}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:element name="facet" type="facetType"/>
	<xs:complexType name="facetType">
		<xs:sequence>
			<xs:element name="singlePattern" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:pattern value="[A-Z]{2}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="multiplePatterns" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:pattern value="[A-Z]{2}"/>
						<xs:pattern value="[a-z]{2}"/>
						<xs:pattern value="[0-9]{2}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="stringEnumeration" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:enumeration value="a"/>
						<xs:enumeration value="b"/>
						<xs:enumeration value="c"/>
						<xs:enumeration value="d"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="typeSafeStringEnumeration" minOccurs="0">
				<xs:simpleType>
					<xs:annotation>
						<xs:appinfo>
							<jaxb:typesafeEnumClass name="TypeSafeStringEnumeration"/>
						</xs:appinfo>
					</xs:annotation>
					<xs:restriction base="xs:string">
						<xs:enumeration value="a"/>
						<xs:enumeration value="b"/>
						<xs:enumeration value="c"/>
						<xs:enumeration value="d"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="intEnumeration" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:int">
						<xs:enumeration value="1"/>
						<xs:enumeration value="2"/>
						<xs:enumeration value="3"/>
						<xs:enumeration value="4"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="dateEnumeration" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:date">
						<xs:enumeration value="2001-12-31"/>
						<xs:enumeration value="2002-01-01"/>
						<xs:enumeration value="2002-02-01"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="timeEnumeration" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:time">
						<xs:enumeration value="23:59:59"/>
						<xs:enumeration value="00:00:00"/>
						<xs:enumeration value="00:00:01"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		</xs:sequence>
		<xs:attribute name="constantAttribute" type="xs:decimal" use="required" fixed="2.2"/>
	</xs:complexType>
	<xs:complexType name="abstractType" abstract="true">
		<xs:sequence>
			<xs:element name="one" type="xs:string"/>
			<xs:element name="two" type="xs:positiveInteger"/>
			<xs:element name="three" type="xs:date"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="concreteType">
		<xs:complexContent>
		    <xs:extension base="abstractType">
				<xs:sequence>
					<xs:element name="four" type="xs:dateTime"/>
					<xs:element name="five" type="xs:base64Binary"/>
				</xs:sequence>
		    </xs:extension>
		</xs:complexContent>
	</xs:complexType>
</xs:schema>
