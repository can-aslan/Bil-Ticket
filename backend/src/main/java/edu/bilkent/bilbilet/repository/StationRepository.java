package edu.bilkent.bilbilet.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import edu.bilkent.bilbilet.enums.StationType;
import edu.bilkent.bilbilet.model.Address;
import edu.bilkent.bilbilet.model.Station;
import edu.bilkent.bilbilet.response.RStationAddress;

@Qualifier("station_repo")
@Repository
public class StationRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    private RowMapper<Station> stationRowMapper = (rs, rowNum) -> {
        Station station = new Station();
        station.setStationId(rs.getInt("station_id"));
        station.setAddressId(rs.getInt("address_id"));
        station.setTitle(rs.getString("title"));
        station.setAbbreviation(rs.getString("abbreviation"));
        station.setStationType(StationType.valueOf(rs.getString("station_type")));
        return station;
    };

    private RowMapper<RStationAddress> rStationAddressRowMapper = (rs, rowNum) -> {
        Station station = new Station();
        station.setStationId(rs.getInt("station_id"));
        station.setAddressId(rs.getInt("address_id"));
        station.setTitle(rs.getString("title"));
        station.setAbbreviation(rs.getString("abbreviation"));
        station.setStationType(StationType.valueOf(rs.getString("station_type")));

        Address address = new Address();
        address.setAddressId(rs.getInt("address_id"));
        address.setCity(rs.getString("city"));
        address.setCountry(rs.getString("country"));
        address.setLatitude(rs.getBigDecimal("latitude"));
        address.setLongitude(rs.getBigDecimal("longitude"));

        RStationAddress rStationAdress = new RStationAddress(station, address);
        return rStationAdress;
    };

    public List<RStationAddress> findStations() {
        String sql = "SELECT * FROM Station NATURAL JOIN Address";

        try {
            return jdbcTemplate.query(sql, rStationAddressRowMapper);
        } catch (EmptyResultDataAccessException e) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Optional<Station> findStationById(int id) {
        String sql = "SELECT * FROM Station WHERE station_id = ?";

        try {
            return Optional.of(jdbcTemplate.queryForObject(sql, stationRowMapper, id));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    public Optional<Station> findStationByTitle(String title) {
        String sql = "SELECT * FROM Station WHERE title = ?";

        try {
            return Optional.of(jdbcTemplate.queryForObject(sql, stationRowMapper, title));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    public Station save(Station station) { // check if exist????????????
        String sql = "INSERT INTO Station (station_type, title, abbreviation, address_id) "
                +
                "VALUES (?, ?, ?, ?)";

        jdbcTemplate.update(
                sql,
                station.getStationType(),
                station.getTitle(),
                station.getAbbreviation(),
                station.getAddressId());

        // TODO: yeni oluşan? stationId'yi al
        // Station new_station = findStationById(station.getStationId()).isPresent()
        // ? findStationById(station.getStation().getStationId()).get()
        // : null;

        // TODO: silinecek
        Station new_station = findStationById(1).isPresent()
                ? findStationById(1).get()
                : null;
        return new_station;
    }

    public boolean existsById(int id) {
        Optional<Station> station = findStationById(id);

        return station.isPresent();
    }

    public boolean existsByTitle(String title) {
        Optional<Station> station = findStationByTitle(title);

        return station.isPresent();
    }
}