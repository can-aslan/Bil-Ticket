package edu.bilkent.bilbilet.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

import edu.bilkent.bilbilet.exception.CarException;
import edu.bilkent.bilbilet.model.Address;
import edu.bilkent.bilbilet.model.Car;
import edu.bilkent.bilbilet.model.CarBrand;
import edu.bilkent.bilbilet.repository.AddressRepository;
import edu.bilkent.bilbilet.repository.CarBrandRepository;
import edu.bilkent.bilbilet.repository.CarRepository;
import edu.bilkent.bilbilet.repository.CompanyCarRepository;
import edu.bilkent.bilbilet.repository.rowmapper.datamodel.CompanyCarRM;
import edu.bilkent.bilbilet.request.AddCompanyCar;
import edu.bilkent.bilbilet.response.RCompanyCar;
import edu.bilkent.bilbilet.utils.ParamUtils;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class CarService {

    private final CarRepository carRepository;
    private final CompanyCarRepository companyCarRepository;
    private final CarBrandRepository carBrandRepository;
    private final AddressRepository addressRepository;

    public Car addCar(Car car) throws Exception {
        try {
            // check if car already exists
            boolean carExist = carRepository.carExistByModelAndBrandAndFuelType(car.getModel(), car.getBrand(), car.getFuelType());

            if (carExist) {
                throw new CarException("Car already exists");
            }

            // check if brand exist
            boolean brandExist = carBrandRepository.brandExist(car.getBrand());

            if (!brandExist) {
                throw new CarException("Brand not found");
            }

            Car savedCar = carRepository.save(car);
            return savedCar;
        } catch (CarException ce) {
            throw ce;
        } catch (Exception e) {
            System.out.println("Car cannot be added yahu");
            e.printStackTrace();
            throw e;
        }
    }

    public RCompanyCar addCompanyCar(AddCompanyCar companyCar) throws Exception {
        try {
            boolean carExist = carRepository.carExistById(companyCar.getCarId());

            if (!carExist) {
                throw new Exception("Car does not exist!");
            }

            //check if company exists
            boolean companyExists = true; //// update this TODO
            
            if (!companyExists) {
                throw new Exception("Company does not exist!");
            }

            // check if address exists
            boolean addressExist = addressRepository.existsByCityCountry(companyCar.getCity(), companyCar.getCountry());
            if (!addressExist) {
                addressRepository.save(new Address(0, companyCar.getCity(), companyCar.getCountry(), BigDecimal.valueOf(0), BigDecimal.valueOf(0)));
            }

            RCompanyCar companyCarId = companyCarRepository.save(companyCar);
            return companyCarId;
        } catch (Exception e) {
            System.out.println("Car cannot be added");
            e.printStackTrace();
            throw e;
        }
    }

    public List<CompanyCarRM> findAllCompanyCar(int companyId) throws Exception {
        try {
            //check if company exists
            boolean companyExists = true; //// update this TODO
                
            if (!companyExists) {
                throw new Exception("Company does not exist!");
            }

            return companyCarRepository.findByCompanyId(companyId);  
        } catch (Exception e) {
            System.out.println("Car cannot be fetched");
            e.printStackTrace();
            throw e;
        }
    }

    public List<CompanyCarRM> findCompanyCarById(int companyCarId) throws Exception {
        try {
            return companyCarRepository.findByCompanyCarId(companyCarId);  
        } catch (Exception e) {
            System.out.println("Car cannot be fetched");
            e.printStackTrace();
            throw e;
        }
    }

    public List<CarBrand> findAllBrand() throws Exception {
        try {
            return carBrandRepository.findAll();  
        } catch (Exception e) {
            System.out.println("Car cannot be fetched");
            e.printStackTrace();
            throw e;
        }
    }

    public List<Car> getCarByProperties(Map<String, Object> requestParams) throws Exception {
        try {
            Map<String, Object> snakeParams = ParamUtils.camelToSnake(requestParams);
            return carRepository.findCarByProperties(snakeParams); //TO DO test           
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}