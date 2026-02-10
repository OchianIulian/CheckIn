package org.example.check_in_api.purchases;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.example.check_in_api.plans.Plan;
import org.example.check_in_api.user.client.ClientEntity;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Purchase {

    @Id
    private Long id;

    @ManyToOne
    private Plan plan;

    @ManyToOne
    private ClientEntity client;
}
