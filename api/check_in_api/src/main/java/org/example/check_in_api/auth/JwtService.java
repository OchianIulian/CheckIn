package org.example.check_in_api.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import org.example.check_in_api.user.AccountType;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JwtService {
    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private long expiration;

    /**
     * Cheia returnată de getSigningKey() este folosită astfel:
     * Semnare: La generarea unui token (în generateToken), metoda .signWith(getSigningKey(), SignatureAlgorithm.HS256) folosește cheia pentru a crea semnătura JWT.
     * Verificare: La validarea sau extragerea datelor dintr-un token (în parseClaims), metoda .setSigningKey(getSigningKey()) folosește aceeași cheie pentru a verifica dacă semnătura token-ului este validă și nu a fost modificată.
     */
    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    public String generateAdminToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .claim("type", AccountType.ADMIN.name())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public String generateClientToken(String phone) {
        return Jwts.builder()
                .setSubject(phone)
                .claim("type", AccountType.CLIENT.name())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public String extractUsername(String token) {
        return parseClaims(token).getSubject();
    }

    public boolean isTokenValid(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    private Claims parseClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public Object extractType(String token) {
        return parseClaims(token).get("type", String.class);
    }
}
