package org.example.check_in_api.user.client;

import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import lombok.extern.slf4j.Slf4j;
import org.example.check_in_api.auth.AuthDtos.RefreshAuthResponse;
import org.example.check_in_api.auth.JwtService;
import org.example.check_in_api.auth.refresh_token.RefreshTokenEntity;
import org.example.check_in_api.auth.refresh_token.RefreshTokenRepository;
import org.example.check_in_api.auth.refresh_token.TokenHash;
import org.example.check_in_api.user.AccountEntity;
import org.example.check_in_api.user.AccountRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import static org.example.check_in_api.user.AccountType.CLIENT;

@Slf4j
@Service
public class ClientAuthService {
    private final ClientRepository clientRepository;
    private final AccountRepository accountRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final OtpService otpService;
    private final JwtService jwtService;
    private final long refreshTtlDays;
    private final SecureRandom random;

    public ClientAuthService(ClientRepository clientRepository, AccountRepository accountRepository,
            OtpService otpService,  JwtService jwtService, RefreshTokenRepository refreshTokenRepository,
            @Value("${jwt.refresh-ttl-days}") long refreshTtlDays) {
        this.clientRepository = clientRepository;
        this.accountRepository = accountRepository;
        this.otpService = otpService;
        this.jwtService = jwtService;
        this.refreshTokenRepository = refreshTokenRepository;
        this.refreshTtlDays = refreshTtlDays;
        this.random = new SecureRandom();
    }

    public void saveClient(PhoneRequest request){
        var client = ClientEntity.builder().phone(request.phone()).build();
        if(clientRepository.findByPhone(request.phone()).isEmpty()) {
            clientRepository.save(client);
        }
        if(accountRepository.findByIdentifier(request.phone()).isEmpty()){
            accountRepository.save(
                    AccountEntity.builder().identifier(request.phone()).accountType(CLIENT).client(client).build());
        }
    }

    public void requestOtp(PhoneRequest request) {
        saveClient(request);
        var otp = otpService.generateOtp(request.phone());

        //TODO: send SMS

        log.info("OTP for {}: {}", request.phone(), otp);
    }

    public RefreshAuthResponse verifyOtp(String phone, String otp) {
        if(!otpService.validateOtp(phone, otp)) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED, "Invalid OTP");
        }

        var client =  clientRepository.findByPhone(phone)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Client not found"));

        var account = accountRepository.findByIdentifier(phone)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Account not found"));

        if (account.getAccountType() != CLIENT) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid account type");
        }

        var accessToken = jwtService.generateClientToken(client.getPhone());

        var refreshRaw = newRefreshTokenRaw();
        var refreshHash = TokenHash.sha256Hex(refreshRaw);

        var refreshTokenEntity = RefreshTokenEntity.builder()
                .accountId(account.getId())
                .tokenHash(refreshHash)
                .createdAt(Instant.now())
                .expiresAt(Instant.now().plus(refreshTtlDays, ChronoUnit.DAYS)).build();
        refreshTokenRepository.save(refreshTokenEntity);

        return new RefreshAuthResponse(accessToken, refreshRaw);
    }

    private String newRefreshTokenRaw() {
        byte[] bytes = new byte[64];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public RefreshAuthResponse refresh(String refreshTokenRaw) {
        var hash = TokenHash.sha256Hex(refreshTokenRaw);

        var current = refreshTokenRepository.findByTokenHash(hash)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid refresh token"));

        if (current.isRevoked() || current.isExpired()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Refresh token not valid");
        }

        var account = accountRepository.findById(current.getAccountId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Account not found"));

        if (account.getAccountType() != CLIENT) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid account type");
        }

        // Rotation: issue new refresh, revoke old one
        var newRaw = newRefreshTokenRaw();
        var newHash = TokenHash.sha256Hex(newRaw);

        var next = RefreshTokenEntity.builder()
                .accountId(account.getId())
                .tokenHash(newHash)
                .createdAt(Instant.now())
                .expiresAt(current.getExpiresAt()).build();
        next = refreshTokenRepository.save(next);

        current.revoke(next.getId());
        refreshTokenRepository.save(current);

        var accessToken = jwtService.generateClientToken(account.getIdentifier());
        return new RefreshAuthResponse(accessToken, newRaw);
    }

    @Transactional
    public void logout(String refreshTokenRaw) {
        var hash = TokenHash.sha256Hex(refreshTokenRaw);
        refreshTokenRepository.findByTokenHash(hash).ifPresent(rt -> {
            if (!rt.isRevoked()) {
                rt.revoke(null);
                refreshTokenRepository.save(rt);
            }
        });
    }
}
