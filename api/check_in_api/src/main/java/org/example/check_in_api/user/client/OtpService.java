package org.example.check_in_api.user.client;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

@Service
public class OtpService {
    private final Map<String, String> otpStore;
    private final Random random;

    public OtpService() {
        otpStore = new ConcurrentHashMap<>();
        random = new Random();
    }

    public String generateOtp(String phone) {
        String otp = String.valueOf(100000 + random.nextInt(900000));
        otpStore.put(phone, otp);
        return otp;
    }

    public boolean validateOtp(String phone, String otp) {
        return otp.equals(otpStore.remove(phone));
    }
}
