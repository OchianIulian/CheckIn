package org.example.check_in_api.user.admin;

import org.example.check_in_api.auth.JwtService;
import org.example.check_in_api.auth.LoginRequest;
import org.example.check_in_api.user.AuthResponse;
import org.example.check_in_api.user.Role;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AdminService {

    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;


    public AdminService(
            AdminRepository adminRepository,
            PasswordEncoder passwordEncoder,
            AuthenticationManager authenticationManager,
            JwtService jwtService) {
        this.adminRepository = adminRepository;
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

        var user = AdminEntity.builder()
                .username(adminRequest.username())
                .password(passwordEncoder.encode(adminRequest.password()))
                .email(adminRequest.email())
                .role(Role.ADMIN.name())
                .phone(adminRequest.phoneNumber())
                .build();

        adminRepository.save(user);
        var token = jwtService.generateAdminToken(user.getUsername());
        return new AuthResponse(token);
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
