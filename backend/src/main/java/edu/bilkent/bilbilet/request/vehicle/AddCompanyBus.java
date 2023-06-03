package edu.bilkent.bilbilet.request.vehicle;

import edu.bilkent.bilbilet.enums.VehicleType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AddCompanyBus {
    @Id
    @NotNull
    private int vehicleId;

    @NotNull
    private int capacity;

    @NotNull
    private int seatConfigurationId;

    @NotNull
    private int companyId;

    @NotNull
    private String plateNumber;
}
