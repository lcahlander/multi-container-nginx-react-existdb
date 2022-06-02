package org.exist.jwttest;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.StringUtils;
import org.exist.xquery.BasicFunction;
import org.exist.xquery.FunctionSignature;
import org.exist.xquery.XPathException;
import org.exist.xquery.XQueryContext;
import org.exist.xquery.value.Sequence;
import org.exist.xquery.value.StringValue;
import org.exist.xquery.value.Type;

import java.util.regex.Pattern;

import static org.exist.xquery.FunctionDSL.*;
import static org.exist.jwttest.JWTModule.functionSignature;

/**
 * Some very simple XQuery example functions implemented
 * in Java.
 */
public class JWTFunctions extends BasicFunction {

    private static final String FS_DECODE_JWT_NAME = "decode";
    static final FunctionSignature FS_DECODE_JWT = functionSignature(
        FS_DECODE_JWT_NAME,
        "Decoding the JWT token string.",
        returns(Type.STRING),
        param("token", Type.STRING, "A token")
    );


    public JWTFunctions(final XQueryContext context, final FunctionSignature signature) {
        super(context, signature);
    }

    @Override
    public Sequence eval(final Sequence[] args, final Sequence contextSequence) throws XPathException {
        switch (getName().getLocalPart()) {

            case FS_DECODE_JWT_NAME:
                final StringValue token = (StringValue) args[0].itemAt(0);
                return decode(token.getStringValue());

            default:
                throw new XPathException(this, "No function: " + getName() + "#" + getSignature().getArgumentCount());
        }
    }

    private Sequence decode(final String token) {
        return new StringValue(deserialize(token));
    }

    public String deserialize(String tokenString) {
        String[] pieces = splitTokenString(tokenString);
        String jwtPayloadSegment = pieces[1];
        return StringUtils.newStringUtf8(Base64.decodeBase64(jwtPayloadSegment));
    }

    /**
     * @param tokenString The original encoded representation of a JWT
     * @return Three components of the JWT as an array of strings
     */
    private String[] splitTokenString(String tokenString) {
        String[] pieces = tokenString.split(Pattern.quote("."));
        if (pieces.length != 3) {
            throw new IllegalStateException("Expected JWT to have 3 segments separated by '"
                    + "." + "', but it has " + pieces.length + " segments");
        }
        return pieces;
    }

}
