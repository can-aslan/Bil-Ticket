CREATE TABLE IF NOT EXISTS User (
    user_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    email VARCHAR(320) UNIQUE NOT NULL,
    telephone VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(255) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS Company (
    company_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    company_title VARCHAR(255) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    type VARCHAR(255) NOT NULL,
    contact_information TEXT,
    business_registration VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (company_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Traveler (
    user_id INT NOT NULL,
    nationality VARCHAR(80) NOT NULL,
    passport_number VARCHAR(30),
    balance DECIMAL(10, 2),
    TCK VARCHAR(11),
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT user_id_exists FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CHECK (balance >= 0)
);

CREATE TABLE IF NOT EXISTS SeatConfiguration (
    seat_configuration_id INT NOT NULL AUTO_INCREMENT,
    seat_configuration_name VARCHAR(50) NOT NULL,
    seating_arrangement VARCHAR(50) NOT NULL,
    total_rows INT NOT NULL,
    total_columns INT NOT NULL,
    premium_econ_class_after INT NOT NULL,
    business_class_after INT NOT NULL,
    first_class_after INT NOT NULL,
    PRIMARY KEY (seat_configuration_id)
);

CREATE TABLE IF NOT EXISTS Address (
    address_id INT NOT NULL AUTO_INCREMENT,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    PRIMARY KEY (address_id)
);

CREATE TABLE IF NOT EXISTS CarBrand (
    brand VARCHAR(255) NOT NULL,
    PRIMARY KEY (brand)
);

CREATE TABLE IF NOT EXISTS Car (
    car_id INT NOT NULL AUTO_INCREMENT,
    capacity INT NOT NULL,
    gear VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    fuel_type VARCHAR(255) NOT NULL,
    photo_url VARCHAR(255),
    website_url VARCHAR(255),
    PRIMARY KEY (car_id),
    FOREIGN KEY (brand) REFERENCES CarBrand(brand) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CompanyCar (
    company_car_id INT NOT NULL AUTO_INCREMENT,
    car_id INT NOT NULL,
    company_id INT NOT NULL,
    address_id INT NOT NULL,
    price_per_day DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (company_car_id),
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES Address(address_id) ON DELETE CASCADE,
    CONSTRAINT price_check CHECK (price_per_day > 0)
);

CREATE TABLE IF NOT EXISTS CompanyPlane (
    plane_id    INT NOT NULL AUTO_INCREMENT,
    tail_number VARCHAR(50) NOT NULL,
    PRIMARY KEY (plane_id)
);

CREATE TABLE IF NOT EXISTS CompanyBus (
    bus_id       INT NOT NULL AUTO_INCREMENT,
    plate_number VARCHAR(50) NOT NULL,
    PRIMARY KEY (bus_id)
);

CREATE TABLE IF NOT EXISTS CompanyVehicle (
    vehicle_id INT NOT NULL AUTO_INCREMENT,
    capacity INT NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    vehicle_reference_id INT,
    seat_configuration_id INT NOT NULL,
    company_id INT NOT NULL,
    PRIMARY KEY (vehicle_id),
    FOREIGN KEY (seat_configuration_id) REFERENCES SeatConfiguration(seat_configuration_id) ON DELETE CASCADE,
    CONSTRAINT capacity_check CHECK (capacity > 0),
    CONSTRAINT vehicle_type_check CHECK (vehicle_type IN ('BUS', 'PLANE'))
);

CREATE TABLE IF NOT EXISTS Station (
    station_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    abbreviation VARCHAR(50) NOT NULL,
    station_type VARCHAR(50) NOT NULL,
    address_id INT NOT NULL,
    PRIMARY KEY (station_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Hotel (
    hotel_id INT NOT NULL AUTO_INCREMENT,
    `name` TEXT NOT NULL,
    avg_price NUMERIC NOT NULL,
    telephone VARCHAR(255) NOT NULL,
    rating NUMERIC NOT NULL,
    website_url VARCHAR(255) NOT NULL,
    cover_photo_url VARCHAR(255) NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    address_id INT NOT NULL,
    PRIMARY KEY (hotel_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Fare (
    fare_id INT NOT NULL AUTO_INCREMENT,
    departure_time TIMESTAMP NOT NULL,
    estimated_arrival_time TIMESTAMP NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    premium_econ_extra_price DECIMAL(10, 2) NOT NULL,
    business_extra_price DECIMAL(10, 2) NOT NULL,
    first_class_extra_price DECIMAL(10, 2) NOT NULL,
    reservation_fee DECIMAL(10, 2) NOT NULL,
    company_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    dep_stat_id INT NOT NULL,
    arrive_stat_id INT NOT NULL,
    PRIMARY KEY (fare_id),
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES CompanyVehicle(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (dep_stat_id) REFERENCES Station(station_id) ON DELETE CASCADE,
    FOREIGN KEY (arrive_stat_id) REFERENCES Station(station_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Ticket (
    ticket_id INT NOT NULL AUTO_INCREMENT,
    ticket_status VARCHAR(50) NOT NULL,
    seat_type VARCHAR(50) NOT NULL,
    fare_id INT NOT NULL,
    traveler_id INT,
    seat_row INT NOT NULL,
    seat_column INT NOT NULL,
    PRIMARY KEY (ticket_id),
    FOREIGN KEY (fare_id) REFERENCES Fare(fare_id) ON DELETE CASCADE,
    FOREIGN KEY (traveler_id) REFERENCES Traveler(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Reservation (
    reservation_id INT NOT NULL AUTO_INCREMENT,
    reservation_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    reserved_until TIMESTAMP NOT NULL,
    ticket_id INT NOT NULL,
    traveler_id INT NOT NULL,
    PRIMARY KEY (reservation_id),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (traveler_id) REFERENCES Traveler(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS JourneyPlan (
    journey_plan_id INT NOT NULL AUTO_INCREMENT,
    plan_title VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (journey_plan_id),
    FOREIGN KEY (user_id) REFERENCES Traveler(user_id) ON DELETE CASCADE,
    CONSTRAINT uc_user_plan UNIQUE (user_id, plan_title) /* user can have only one plan with the same title */
);

CREATE TABLE IF NOT EXISTS Journey (
    journey_id INT NOT NULL AUTO_INCREMENT,
    journey_title VARCHAR(255) NOT NULL,
    journey_plan_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (journey_id),
    FOREIGN KEY (journey_plan_id) REFERENCES JourneyPlan(journey_plan_id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT NOT NULL AUTO_INCREMENT,
    transaction_type VARCHAR(255) NOT NULL,
    transaction_amount NUMERIC NOT NULL,
    receiver_id INT,
    sender_id INT,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (receiver_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT transaction_type_constraint
        CHECK (transaction_type IN ('REFUND', 'BUY_TICKET_WITH_BALANCE', 'WITHDRAW', 'ADD_FUNDS', 'BUY_TICKET_WITH_CARD', 'TRANSFER')),
    CONSTRAINT transaction_amount_check
        CHECK (transaction_amount BETWEEN 0 AND 50000)
);

CREATE TABLE IF NOT EXISTS RentDetail (
    rent_id INT NOT NULL AUTO_INCREMENT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    user_id INT NOT NULL,
    company_car_id INT NOT NULL,
    PRIMARY KEY (rent_id),
    FOREIGN KEY (company_car_id) REFERENCES CompanyCar(company_car_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Traveler(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Review (
    review_id INT NOT NULL AUTO_INCREMENT,
    comment TEXT NOT NULL,
    punctuality DOUBLE NOT NULL,
    cleanliness DOUBLE NOT NULL,
    customer_service DOUBLE NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY (user_id) REFERENCES Traveler(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CompanyReview (
    review_id INT NOT NULL,
    company_id INT NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY (review_id) REFERENCES Review(review_id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES Company(company_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TripReview (
    review_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY (review_id) REFERENCES Review(review_id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id) ON DELETE CASCADE
);

