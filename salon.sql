-- https://www.freecodecamp.org/
-- Curriculum: Relational Databases Certification
-- Project: Build a Salon Appointment Scheduler
-- Copyright (C) 2026 Maksim Petrenko


-- SCHEMA ----------------------------------------------------------------------

DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS services;

-- services
CREATE TABLE services (
    service_id INTEGER     NOT NULL, -- PK: serial number
    name       VARCHAR(20) NOT NULL,
    -- constraints
    PRIMARY KEY (service_id)
);

-- customers
CREATE TABLE customers (
    customer_id INTEGER     NOT NULL, -- PK: random number
    phone       VARCHAR(20) NOT NULL,
    name        VARCHAR(50) NOT NULL,    
    -- constraints
    PRIMARY KEY (customer_id),
    UNIQUE (phone)
);

-- appointments
CREATE TABLE appointments (
    appointment_id INTEGER     NOT NULL, -- PK: random number
    service_id     INTEGER     NOT NULL,
    customer_id    INTEGER     NOT NULL,
    time           VARCHAR(10) NOT NULL,
    -- constraints
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (service_id) REFERENCES services (service_id)
);


-- DATA ------------------------------------------------------------------------

-- services
INSERT INTO services VALUES
    (1, 'cut'),
    (2, 'color'),
    (3, 'perm'),
    (4, 'style'),
    (5, 'trim');

