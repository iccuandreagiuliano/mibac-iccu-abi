//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.09.05 at 09:58:07 AM CEST 
//


package xml.xsd.v15;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for modoInternetType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="modoInternetType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="libero"/>
 *     &lt;enumeration value="a pagamento"/>
 *     &lt;enumeration value="a tempo"/>
 *     &lt;enumeration value="limitato"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "modoInternetType")
@XmlEnum
public enum ModoInternetType {

    @XmlEnumValue("libero")
    LIBERO("libero"),
    @XmlEnumValue("a pagamento")
    A_PAGAMENTO("a pagamento"),
    @XmlEnumValue("a tempo")
    A_TEMPO("a tempo"),
    @XmlEnumValue("limitato")
    LIMITATO("limitato");
    private final String value;

    ModoInternetType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static ModoInternetType fromValue(String v) {
        for (ModoInternetType c: ModoInternetType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
