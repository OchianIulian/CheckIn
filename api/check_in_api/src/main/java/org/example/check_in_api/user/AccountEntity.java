package org.example.check_in_api.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.example.check_in_api.user.admin.AdminEntity;
import org.example.check_in_api.user.client.ClientEntity;

@Entity
@Table(name = "accounts")
@Getter
@Setter
@Builder
@RequiredArgsConstructor
@AllArgsConstructor
public class AccountEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private AccountType accountType;

    @Column(length = 100, unique = true, nullable = false)
    private String identifier;

    @OneToOne
    @JoinColumn(unique = true)
    private AdminEntity admin;

    @OneToOne
    @JoinColumn(unique = true)
    private ClientEntity client;

}
