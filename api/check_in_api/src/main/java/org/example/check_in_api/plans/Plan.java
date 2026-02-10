package org.example.check_in_api.plans;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.example.check_in_api.locations.Location;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Plan {

    @Id
    private Long id;
    private String title;
    private Integer price;
    private Integer durationInDays;
    private String description;
    private Integer numberOfEntries;
    private Boolean active;

    @ManyToOne
    private Location location;
}
