package org.example.check_in_api.locations;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Embeddable
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Address {
    @Column(name = "address", length = 120, nullable = false)
    private String addressLine;

    @Column(name = "city", length = 60, nullable = false)
    private String city;

    @Column(name = "region", length = 60)
    private String region; // judet/sector/state

    @Column(name = "postal_code", length = 20)
    private String postalCode;

    @Column(name = "country", length = 2, nullable = false)
    private String countryIso2;
}

