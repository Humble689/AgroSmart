-- Active: 1738701282055@@127.0.0.1@3306@bscs
CREATE TABLE Farmers (
    farmer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    contact_info VARCHAR(100) NOT NULL,
    farm_size DECIMAL(10,2) NOT NULL,
    registration_date DATE NOT NULL
);

-- Create Crops table
CREATE TABLE Crops (
    crop_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    growth_duration INT NOT NULL, -- in days
    ideal_conditions TEXT NOT NULL
);

-- Create Farms table
CREATE TABLE Farms (
    farm_id INT PRIMARY KEY AUTO_INCREMENT,
    farmer_id INT NOT NULL,
    crop_id INT NOT NULL,
    location VARCHAR(200) NOT NULL,
    size DECIMAL(10,2) NOT NULL,
    yield_estimate DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id),
    FOREIGN KEY (crop_id) REFERENCES Crops(crop_id)
);

-- Create Market Prices table
CREATE TABLE Market_Prices (
    market_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_id INT NOT NULL,
    location VARCHAR(200) NOT NULL,
    price_per_kg DECIMAL(10,2) NOT NULL,
    date_recorded DATE NOT NULL,
    FOREIGN KEY (crop_id) REFERENCES Crops(crop_id)
);

-- Create Weather Data table
CREATE TABLE Weather_Data (
    weather_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(200) NOT NULL,
    temperature DECIMAL(5,2) NOT NULL,
    rainfall DECIMAL(10,2) NOT NULL,
    humidity DECIMAL(5,2) NOT NULL,
    date_recorded DATE NOT NULL
);

-- Create Supply Chain & Distribution table
CREATE TABLE Supply_Chain_Distribution (
    distribution_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_id INT NOT NULL,
    farmer_id INT NOT NULL,
    buyer_name VARCHAR(100) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    price_sold DECIMAL(10,2) NOT NULL,
    date_of_sale DATE NOT NULL,
    FOREIGN KEY (crop_id) REFERENCES Crops(crop_id),
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id)
);

-- Add data validation constraints
use agro;

-- Farmers table constraints
ALTER TABLE Farmers
    ADD CONSTRAINT chk_farm_size_positive CHECK (farm_size > 0),
    ADD CONSTRAINT chk_registration_date CHECK (registration_date <= '9999-12-31'),
    ADD CONSTRAINT chk_contact_info_format CHECK (contact_info REGEXP '^[0-9+()-]{10,}$');

-- Crops table constraints
ALTER TABLE Crops
    ADD CONSTRAINT chk_growth_duration_positive CHECK (growth_duration > 0),
    ADD CONSTRAINT chk_category CHECK (category IN ('Grains', 'Vegetables', 'Fruits', 'Legumes', 'Root Crops', 'Other'));

-- Farms table constraints
ALTER TABLE Farms
    ADD CONSTRAINT chk_farm_size_positive CHECK (size > 0),
    ADD CONSTRAINT chk_yield_estimate_positive CHECK (yield_estimate > 0);

-- Market Prices table constraints
ALTER TABLE Market_Prices
    ADD CONSTRAINT chk_pricepositive CHECK (price_per_kg > 0),
    ADD CONSTRAINT chk_marketdate CHECK (date_recorded <= '9999-12-31');

use agro;
-- Weather Data table constraints
ALTER TABLE Weather_Data
    ADD CONSTRAINT chk_temperature_range CHECK (temperature BETWEEN -50 AND 50),
    ADD CONSTRAINT chk_rainfall_positive CHECK (rainfall >= 0),
    ADD CONSTRAINT chk_humidity_range CHECK (humidity BETWEEN 0 AND 100),
    ADD CONSTRAINT chk_weather_date CHECK (date_recorded <= '9999-12-31');

-- Supply Chain & Distribution table constraints
ALTER TABLE Supply_Chain_Distribution
    ADD CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    ADD CONSTRAINT chk_price_sold_positive CHECK (price_sold > 0),
    ADD CONSTRAINT chk_sale_date CHECK (date_of_sale <= '9999-12-31');

-- Add indexes for better query performance
CREATE INDEX idx_farmer_location ON Farmers(location);
CREATE INDEX idx_crop_category ON Crops(category);
CREATE INDEX idx_farm_location ON Farms(location);
CREATE INDEX idx_market_location ON Market_Prices(location);
CREATE INDEX idx_weather_location ON Weather_Data(location);
CREATE INDEX idx_weather_date ON Weather_Data(date_recorded);
CREATE INDEX idx_market_date ON Market_Prices(date_recorded);
CREATE INDEX idx_distribution_date ON Supply_Chain_Distribution(date_of_sale);
 use agro;
-- Create roles for different user types
CREATE ROLE farmer_role;
CREATE ROLE market_analyst_role;
CREATE ROLE weather_analyst_role;
CREATE ROLE admin_role;
CREATE ROLE buyer_role;

-- Grant privileges to roles
-- Farmer role privileges
GRANT SELECT ON Farmers TO farmer_role;
GRANT SELECT, INSERT, UPDATE ON Farms TO farmer_role;
GRANT SELECT ON Crops TO farmer_role;
GRANT SELECT ON Market_Prices TO farmer_role;
GRANT SELECT ON Weather_Data TO farmer_role;
GRANT SELECT, INSERT ON Supply_Chain_Distribution TO farmer_role;

-- Market analyst role privileges
GRANT SELECT ON Farmers TO market_analyst_role;
GRANT SELECT ON Farms TO market_analyst_role;
GRANT SELECT ON Crops TO market_analyst_role;
GRANT SELECT, INSERT, UPDATE ON Market_Prices TO market_analyst_role;
GRANT SELECT ON Supply_Chain_Distribution TO market_analyst_role;

-- Weather analyst role privileges
GRANT SELECT, INSERT, UPDATE ON Weather_Data TO weather_analyst_role;
GRANT SELECT ON Farms TO weather_analyst_role;

-- Admin role privileges
GRANT ALL PRIVILEGES ON *.* TO admin_role;

-- Buyer role privileges
GRANT SELECT ON Crops TO buyer_role;
GRANT SELECT ON Market_Prices TO buyer_role;
GRANT SELECT, INSERT ON Supply_Chain_Distribution TO buyer_role;

-- Create views for common queries
-- View for farmer's farm summary
CREATE VIEW farmer_farm_summary AS
SELECT 
    f.farmer_id,
    fm.name AS farmer_name,
    c.name AS crop_name,
    f.location,
    f.size,
    f.yield_estimate
FROM Farms f
JOIN Farmers fm ON f.farmer_id = fm.farmer_id
JOIN Crops c ON f.crop_id = c.crop_id;

-- View for market price trends
CREATE VIEW market_price_trends AS
SELECT 
    c.name AS crop_name,
    mp.location,
    mp.price_per_kg,
    mp.date_recorded
FROM Market_Prices mp
JOIN Crops c ON mp.crop_id = c.crop_id
ORDER BY mp.date_recorded DESC;

-- View for weather impact analysis
CREATE VIEW weather_impact_analysis AS
SELECT 
    w.location,
    w.date_recorded,
    w.temperature,
    w.rainfall,
    w.humidity,
    f.farm_id,
    c.name AS crop_name
FROM Weather_Data w
JOIN Farms f ON w.location = f.location
JOIN Crops c ON f.crop_id = c.crop_id;

-- Create stored procedures
-- Procedure to add a new farmer with farm
DELIMITER //
CREATE PROCEDURE add_new_farmer_with_farm(
    IN p_name VARCHAR(100),
    IN p_location VARCHAR(200),
    IN p_contact_info VARCHAR(100),
    IN p_farm_size DECIMAL(10,2),
    IN p_crop_id INT,
    IN p_farm_location VARCHAR(200),
    IN p_farm_size_hectares DECIMAL(10,2),
    IN p_yield_estimate DECIMAL(10,2)
)
BEGIN
    DECLARE new_farmer_id INT;
    
    -- Insert new farmer
    INSERT INTO Farmers (name, location, contact_info, farm_size, registration_date)
    VALUES (p_name, p_location, p_contact_info, p_farm_size, CURRENT_DATE);
    
    -- Get the new farmer's ID
    SET new_farmer_id = LAST_INSERT_ID();
    
    -- Insert farm for the new farmer
    INSERT INTO Farms (farmer_id, crop_id, location, size, yield_estimate)
    VALUES (new_farmer_id, p_crop_id, p_farm_location, p_farm_size_hectares, p_yield_estimate);
END //
DELIMITER ;

-- Procedure to update market prices
DELIMITER //
CREATE PROCEDURE update_market_prices(
    IN p_crop_id INT,
    IN p_location VARCHAR(200),
    IN p_price_per_kg DECIMAL(10,2)
)
BEGIN
    INSERT INTO Market_Prices (crop_id, location, price_per_kg, date_recorded)
    VALUES (p_crop_id, p_location, p_price_per_kg, CURRENT_DATE);
END //
DELIMITER ;

-- Create triggers
-- Trigger to log market price changes
DELIMITER //
CREATE TRIGGER after_market_price_insert
AFTER INSERT ON Market_Prices
FOR EACH ROW
BEGIN
    INSERT INTO Market_Price_Log (
        crop_id,
        location,
        old_price,
        new_price,
        change_date
    )
    VALUES (
        NEW.crop_id,
        NEW.location,
        NULL,
        NEW.price_per_kg,
        CURRENT_TIMESTAMP
    );
END //
DELIMITER ;

-- Trigger to validate farm size against farmer's total farm size
DELIMITER //
CREATE TRIGGER before_farm_insert
BEFORE INSERT ON Farms
FOR EACH ROW
BEGIN
    DECLARE total_farm_size DECIMAL(10,2);
    DECLARE farmer_total_size DECIMAL(10,2);
    
    -- Get total size of all farms for this farmer
    SELECT COALESCE(SUM(size), 0) INTO total_farm_size
    FROM Farms
    WHERE farmer_id = NEW.farmer_id;
    
    -- Get farmer's total farm size
    SELECT farm_size INTO farmer_total_size
    FROM Farmers
    WHERE farmer_id = NEW.farmer_id;
    
    -- Check if adding new farm would exceed total size
    IF (total_farm_size + NEW.size) > farmer_total_size THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Farm size exceeds farmer total farm size';
    END IF;
END //
DELIMITER ;

-- Create Market_Price_Log table for trigger
CREATE TABLE Market_Price_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_id INT NOT NULL,
    location VARCHAR(200) NOT NULL,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2) NOT NULL,
    change_date TIMESTAMP NOT NULL,
    FOREIGN KEY (crop_id) REFERENCES Crops(crop_id)
);