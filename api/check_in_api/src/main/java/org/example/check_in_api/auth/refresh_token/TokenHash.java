package org.example.check_in_api.auth.refresh_token;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import lombok.NoArgsConstructor;

@NoArgsConstructor
public class TokenHash {
    public static String sha256Hex(String value){
        try {
            var md = MessageDigest.getInstance("SHA-256");//apiul standard Java pentru functii hash
            byte[] digest = md.digest(value.getBytes(StandardCharsets.UTF_8));
            var sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("Cannot hash token", e);
        }
    }
}
