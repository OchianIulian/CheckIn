package org.example.check_in_api.user.client;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClientRepository  extends JpaRepository<ClientEntity, Long> {
        Optional<ClientEntity> findByPhone(String phone);
}
