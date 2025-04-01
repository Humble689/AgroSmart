-- Smart Agriculture Database System 
CREATE DATABASE smart_agriculture;
-- Create User table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    user_type VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Create Farm table
CREATE TABLE Farms (
    farm_id SERIAL PRIMARY KEY,
    owner_id INTEGER REFERENCES Users(user_id),
    farm_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    total_area DECIMAL(10,2) NOT NULL,
    soil_type VARCHAR(50),
    registration_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Create Crop table
CREATE TABLE Crops (
    crop_id SERIAL PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    description TEXT,
    typical_yield_per_hectare DECIMAL(10,2),
    water_requirement DECIMAL(10,2)
);

-- Create FarmCrop table (links farms with crops)
CREATE TABLE FarmCrops (
    farm_id INTEGER REFERENCES Farms(farm_id),
    crop_id INTEGER REFERENCES Crops(crop_id),
    planting_date DATE NOT NULL,
    expected_harvest_date DATE NOT NULL,
    actual_harvest_date DATE,
    yield_achieved DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'PLANNED',
    PRIMARY KEY (farm_id, crop_id)
);

-- Create Sensor table
CREATE TABLE Sensors (
    sensor_id SERIAL PRIMARY KEY,
    farm_id INTEGER REFERENCES Farms(farm_id),
    sensor_type VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    installation_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Create SensorReadings table
CREATE TABLE SensorReadings (
    reading_id SERIAL PRIMARY KEY,
    sensor_id INTEGER REFERENCES Sensors(sensor_id),
    timestamp TIMESTAMP NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL
);

-- Create WeatherData table
CREATE TABLE WeatherData (
    weather_id SERIAL PRIMARY KEY,
    farm_id INTEGER REFERENCES Farms(farm_id),
    timestamp TIMESTAMP NOT NULL,
    temperature DECIMAL(5,2) NOT NULL,
    humidity DECIMAL(5,2) NOT NULL,
    rainfall DECIMAL(10,2) NOT NULL,
    wind_speed DECIMAL(5,2) NOT NULL
);

-- Create Resources table
CREATE TABLE Resources (
    resource_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    cost_per_unit DECIMAL(10,2) NOT NULL
);

-- Create FarmResources table (inventory)
CREATE TABLE FarmResources (
    farm_id INTEGER REFERENCES Farms(farm_id),
    resource_id INTEGER REFERENCES Resources(resource_id),
    quantity DECIMAL(10,2) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (farm_id, resource_id)
);

-- Create Advisories table
CREATE TABLE Advisories (
    advisory_id SERIAL PRIMARY KEY,
    created_by INTEGER REFERENCES Users(user_id),
    farm_id INTEGER REFERENCES Farms(farm_id),
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    status VARCHAR(20) DEFAULT 'DRAFT'
);

-- Create MarketPrices table
CREATE TABLE MarketPrices (
    price_id SERIAL PRIMARY KEY,
    crop_id INTEGER REFERENCES Crops(crop_id),
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    market_location VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP NOT NULL
);

-- Create basic indexes
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_farms_owner ON Farms(owner_id);
CREATE INDEX idx_farmcrops_farm ON FarmCrops(farm_id);
CREATE INDEX idx_sensors_farm ON Sensors(farm_id);
CREATE INDEX idx_sensorreadings_sensor ON SensorReadings(sensor_id);
CREATE INDEX idx_weatherdata_farm ON WeatherData(farm_id);
CREATE INDEX idx_farmresources_farm ON FarmResources(farm_id);
CREATE INDEX idx_advisories_farm ON Advisories(farm_id);
CREATE INDEX idx_marketprices_crop ON MarketPrices(crop_id);

-- Add table comments
COMMENT ON TABLE Users IS 'Stores user account information';
COMMENT ON TABLE Farms IS 'Contains information about agricultural farms';
COMMENT ON TABLE Crops IS 'Stores information about different types of crops';
COMMENT ON TABLE FarmCrops IS 'Links farms with crops and stores crop-specific information';
COMMENT ON TABLE Sensors IS 'Manages IoT sensors deployed on farms';
COMMENT ON TABLE SensorReadings IS 'Stores sensor data readings';
COMMENT ON TABLE WeatherData IS 'Records weather information for farms';
COMMENT ON TABLE Resources IS 'Stores information about agricultural resources';
COMMENT ON TABLE FarmResources IS 'Tracks resource usage and inventory for farms';
COMMENT ON TABLE Advisories IS 'Manages agricultural advisories and recommendations';
COMMENT ON TABLE MarketPrices IS 'Tracks market prices for different crops'; 