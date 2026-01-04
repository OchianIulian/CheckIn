package org.example.check_in_api.auth;

import org.example.check_in_api.user.AdminRequest;
import org.example.check_in_api.user.AuthResponse;
import org.example.check_in_api.user.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("auth/admin")
public class AdminAuthController {

    private UserService userService;

    public AdminAuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> signup(@RequestBody AdminRequest request) {
        var response = userService.registerAndLogin(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        var response = userService.login(request);
        return ResponseEntity.ok(response);
    }



}

