package org.example.check_in_api.auth;

import jakarta.validation.constraints.NotBlank;

public class AuthDtos {
    public record AuthResponse(@NotBlank String token) {}

    public record RefreshAuthResponse(@NotBlank String accessToken, @NotBlank String refreshToken) {}

    public record LogoutRequest(@NotBlank String refreshToken) {}

    public record ClientLoginRequest(@NotBlank String phone, @NotBlank String otp) {}

    public record RefreshRequest(@NotBlank String refreshToken) {}

}
