package org.example.check_in_api.user.admin;

import org.example.check_in_api.auth.AuthDtos.AuthResponse;
import org.example.check_in_api.auth.JwtService;
import org.example.check_in_api.auth.LoginRequest;
import org.example.check_in_api.user.AccountEntity;
import org.example.check_in_api.user.AccountRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import static org.example.check_in_api.user.AccountType.ADMIN;

@Service
public class AdminService {

    private final AdminRepository adminRepository;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;


    public AdminService(
            AdminRepository adminRepository,
            AccountRepository accountRepository,
            PasswordEncoder passwordEncoder,
            AuthenticationManager authenticationManager,
            JwtService jwtService) {
        this.adminRepository = adminRepository;
        this.accountRepository = accountRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }


    public AuthResponse registerAndLogin(AdminRequest adminRequest) throws ResponseStatusException {
        if (adminRepository.existsByUsername(adminRequest.username())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT, "Username already exists");
        }

        if (adminRepository.existsByEmail(adminRequest.email())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT, "Email already exists");
        }

        var user = buildAdmin(adminRequest);
        adminRepository.save(user);

        var account = buildAccount(adminRequest, user);
        accountRepository.save(account);

        var token = jwtService.generateAdminToken(user.getUsername());
        return new AuthResponse(token);
    }

    private AdminEntity buildAdmin(AdminRequest adminRequest) {
        return AdminEntity.builder()
                .username(adminRequest.username())
                .password(passwordEncoder.encode(adminRequest.password()))
                .email(adminRequest.email())
                .phone(adminRequest.phoneNumber())
                .build();
    }

    private static AccountEntity buildAccount(AdminRequest adminRequest, AdminEntity user) {
        return AccountEntity.builder()
                .identifier(adminRequest.username())
                .accountType(ADMIN)
                .admin(user)
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.username(),
                        request.password()
                )
        );

        var token = jwtService.generateAdminToken(authentication.getName());
        return new AuthResponse(token);
    }
}
