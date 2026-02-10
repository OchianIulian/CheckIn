package org.example.check_in_api.locations;

import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.example.check_in_api.plans.Plan;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Location {

    @Id
    private Long id;
    private String name;
    private String description;
    @Embedded
    private Address address;
    @OneToMany
    private List<Plan> plan;

}
