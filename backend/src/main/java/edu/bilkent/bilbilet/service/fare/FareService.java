package edu.bilkent.bilbilet.service.fare;

import java.util.Optional;
import org.springframework.stereotype.Service;
import edu.bilkent.bilbilet.exception.CompanyNotFoundException;
import edu.bilkent.bilbilet.exception.InsertionFailedException;
import edu.bilkent.bilbilet.model.Company;
import edu.bilkent.bilbilet.model.Fare;
import edu.bilkent.bilbilet.repository.CompanyRepository;
import edu.bilkent.bilbilet.repository.fare.FareRepository;
import edu.bilkent.bilbilet.request.fare.CreateFare;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FareService {
    private final FareRepository fareRepository;    
    private final CompanyRepository companyRepository;

    public Fare createFare(CreateFare fareInfo) throws Exception {     
        try {
            // Check if the given company name exists
            Optional<Company> optionalCompany = companyRepository.getCompanyByName(fareInfo.getCompanyName());
            
            if (!optionalCompany.isPresent()) {
                throw new CompanyNotFoundException("Could not found company with the name \"" + fareInfo.getCompanyName() + "\".");
            }

            // If the company name exists, continue
            Company company = optionalCompany.get();
            
            // Set companyId of fareToAdd to the existing company
            Fare fareToAdd = fareInfo.getFare();
            fareToAdd.setCompanyId(company.getCompany_id());

            // ASSUMED: vehicleId is already SET by the frontend request
            // ASSUMED: depStationId is already SET by the frontend request
            // ASSUMED: arrStationId is already SET by the frontend request

            Optional<Fare> newFare = fareRepository.createFare(fareToAdd);

            if (!newFare.isPresent()) {
                throw new InsertionFailedException("Fare could not be created.");
            }
    
            return newFare.get();
        }
        catch (InsertionFailedException ife) {
            throw ife;
        }
        catch (CompanyNotFoundException cnfe) {
            throw cnfe;
        }
        catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}
