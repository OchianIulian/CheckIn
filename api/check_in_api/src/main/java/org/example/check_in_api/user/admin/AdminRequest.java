package org.example.check_in_api.user.admin;

public record AdminRequest(String role, String username, String password, String email, String phoneNumber) {}
