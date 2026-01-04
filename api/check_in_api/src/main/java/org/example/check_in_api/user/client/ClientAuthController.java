package org.example.check_in_api.user.client;

import lombok.extern.slf4j.Slf4j;
import org.example.check_in_api.auth.JwtService;
import org.example.check_in_api.user.AuthResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@RestController
@RequestMapping("/auth/client")
public class ClientAuthController {
    private final ClientRepository clientRepository;
    private final OtpService otpService;
    private final JwtService jwtService;

    public ClientAuthController(
            ClientRepository clientRepository,
            OtpService otpService,
            JwtService jwtService
    ) {
        this.clientRepository = clientRepository;
        this.otpService = otpService;
        this.jwtService = jwtService;
    }

    @PostMapping
    public ResponseEntity<Void> requestOtp(@RequestBody PhoneRequest request) {
        if(clientRepository.findByPhone(request.phone()).isEmpty()) {
            clientRepository.save(
                    new ClientEntity(null, request.phone()));
        }

        var otp = otpService.generateOtp(request.phone());

        //TODO: send SMS

        log.info("OTP for {}: {}", request.phone(), otp);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<AuthResponse> verifyOtp(@RequestBody VerifyOtpRequest request) {
        if(!otpService.validateOtp(request.phone(), request.otp())) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED, "Invalid OTP");
        }

        var client =  clientRepository.findByPhone(request.phone())
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Client not found"));

        var token = jwtService.generateClientToken(client.getPhone());

        return ResponseEntity.ok(new AuthResponse(token));
    }


}
