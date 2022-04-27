package org.exist.jwttest;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.core.JsonParser;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.StringUtils;
import org.exist.xquery.BasicFunction;
import org.exist.xquery.FunctionSignature;
import org.exist.xquery.XPathException;
import org.exist.xquery.XQueryContext;
import org.exist.xquery.value.Sequence;
import org.exist.xquery.value.StringValue;
import org.exist.xquery.value.Type;

import java.io.UnsupportedEncodingException;
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
        "An example function that returns <hello>world</hello>.",
        returns(Type.STRING),
            param("token", Type.STRING, "A token"),
            param("secret", Type.STRING, "The secret")
    );


    public JWTFunctions(final XQueryContext context, final FunctionSignature signature) {
        super(context, signature);
    }

    @Override
    public Sequence eval(final Sequence[] args, final Sequence contextSequence) throws XPathException {
        switch (getName().getLocalPart()) {

            case FS_DECODE_JWT_NAME:
                final StringValue token = (StringValue) args[0].itemAt(0);
                final StringValue secret = (StringValue) args[1].itemAt(0);
                return decode(token.getStringValue(), secret.getStringValue());

            default:
                throw new XPathException(this, "No function: " + getName() + "#" + getSignature().getArgumentCount());
        }
    }

    private Sequence decode(final String token, final String secret) {
        return new StringValue(deserialize(token));
//        try {
//            JWTVerifier verifier = JWT.require(Algorithm.HMAC256(secret))
//                    .withIssuer("auth0")
//                    .build();
//            DecodedJWT jwt = verifier.verify(token);
//            return new StringValue(jwt.getPayload());
//        } catch (JWTDecodeException e) {
//            throw new XPathException(this, "JWT Decode exception", e);
//        } catch (Exception e) {
//            throw new XPathException(this, "Algorithm exception", e);
//        }
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
