package org.example.check_in_api.user;

import org.example.check_in_api.auth.JwtService;
import org.example.check_in_api.auth.LoginRequest;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;


    public UserService(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            AuthenticationManager authenticationManager,
            JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    public void registerAndLogin(ClientRequest clientRequest) {
        var user = UserEntity.builder()
                .username(null)
                .password(null)
                .email(null)
                .role(String.valueOf(Role.ADMIN))
                .phone(clientRequest.phoneNumber())
                .build();
        userRepository.save(user);
    }

    public AuthResponse registerAndLogin(AdminRequest adminRequest) throws ResponseStatusException {
        if (userRepository.existsByUsername(adminRequest.username())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT, "Username already exists");
        }

        if (userRepository.existsByEmail(adminRequest.email())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT, "Email already exists");
        }

        var user = UserEntity.builder()
                .username(adminRequest.username())
                .password(passwordEncoder.encode(adminRequest.password()))
                .email(adminRequest.email())
                .role(Role.ADMIN.name())
                .phone(adminRequest.phoneNumber())
                .build();

        userRepository.save(user);
        var token = jwtService.generateToken(user.getUsername());
        return new AuthResponse(token);
    }

    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.username(),
                        request.password()
                )
        );

        String token = jwtService.generateToken(authentication.getName());
        return new AuthResponse(token);
    }


}
