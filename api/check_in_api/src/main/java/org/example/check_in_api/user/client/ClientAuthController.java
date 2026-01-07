package org.example.check_in_api.user.client;

import org.example.check_in_api.auth.AuthDtos.LogoutRequest;
import org.example.check_in_api.auth.AuthDtos.RefreshAuthResponse;
import org.example.check_in_api.auth.AuthDtos.RefreshRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/auth/client")
public class ClientAuthController {
    private final ClientAuthService clientAuthService;

    public ClientAuthController(
            ClientAuthService clientAuthService) {
        this.clientAuthService = clientAuthService;
    }

    @PostMapping
    public ResponseEntity<Void> requestOtp(@RequestBody PhoneRequest request) {
        clientAuthService.requestOtp(request);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<RefreshAuthResponse> verifyOtp(@RequestBody VerifyOtpRequest request) {
        return ResponseEntity.ok(clientAuthService.verifyOtp(request.phone(), request.otp()));
    }

    @PostMapping("/refresh")
    public ResponseEntity<RefreshAuthResponse> refresh(@RequestBody RefreshRequest request) {
        var res = clientAuthService.refresh(request.refreshToken());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestBody LogoutRequest request) {
        clientAuthService.logout(request.refreshToken());
        return ResponseEntity.noContent().build();
    }

}
