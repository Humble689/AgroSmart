# Smart Agriculture Database System - Enhanced Entity-Relationship Model

## Entity Types and Their Attributes

### 1. User
- **Primary Key**: user_id (UUID)
- **Attributes**:
  - username (VARCHAR(50), UNIQUE)
  - email (VARCHAR(100), UNIQUE)
  - password_hash (VARCHAR(255))
  - full_name (VARCHAR(100))
  - phone_number (VARCHAR(20))
  - user_type (ENUM: 'FARMER', 'COOPERATIVE_MEMBER', 'EXTENSION_OFFICER', 'RESEARCHER', 'ADMIN')
  - created_at (TIMESTAMP)
  - last_login (TIMESTAMP)
  - status (ENUM: 'ACTIVE', 'INACTIVE', 'SUSPENDED')

### 2. Farm
- **Primary Key**: farm_id (UUID)
- **Foreign Key**: owner_id (UUID) REFERENCES User(user_id)
- **Attributes**:
  - farm_name (VARCHAR(100))
  - location (POINT)
  - total_area (DECIMAL(10,2))
  - soil_type (VARCHAR(50))
  - registration_date (DATE)
  - status (ENUM: 'ACTIVE', 'INACTIVE', 'PENDING')

### 3. Crop
- **Primary Key**: crop_id (UUID)
- **Attributes**:
  - crop_name (VARCHAR(100))
  - scientific_name (VARCHAR(100))
  - growing_season (VARCHAR(50))
  - typical_yield_per_hectare (DECIMAL(10,2))
  - water_requirement (DECIMAL(10,2))
  - description (TEXT)

### 4. FarmCrop
- **Primary Key**: (farm_id, crop_id)
- **Foreign Keys**:
  - farm_id (UUID) REFERENCES Farm(farm_id)
  - crop_id (UUID) REFERENCES Crop(crop_id)
- **Attributes**:
  - planting_date (DATE)
  - expected_harvest_date (DATE)
  - actual_harvest_date (DATE)
  - yield_achieved (DECIMAL(10,2))
  - status (ENUM: 'PLANNED', 'PLANTED', 'GROWING', 'HARVESTED', 'FAILED')

### 5. Sensor
- **Primary Key**: sensor_id (UUID)
- **Foreign Key**: farm_id (UUID) REFERENCES Farm(farm_id)
- **Attributes**:
  - sensor_type (ENUM: 'SOIL_MOISTURE', 'TEMPERATURE', 'HUMIDITY', 'LIGHT', 'PH')
  - location (POINT)
  - installation_date (DATE)
  - last_maintenance_date (DATE)
  - status (ENUM: 'ACTIVE', 'INACTIVE', 'MAINTENANCE')

### 6. SensorReading
- **Primary Key**: reading_id (UUID)
- **Foreign Key**: sensor_id (UUID) REFERENCES Sensor(sensor_id)
- **Attributes**:
  - timestamp (TIMESTAMP)
  - value (DECIMAL(10,2))
  - unit (VARCHAR(20))
  - quality_score (INTEGER)

### 7. WeatherData
- **Primary Key**: weather_id (UUID)
- **Foreign Key**: farm_id (UUID) REFERENCES Farm(farm_id)
- **Attributes**:
  - timestamp (TIMESTAMP)
  - temperature (DECIMAL(5,2))
  - humidity (DECIMAL(5,2))
  - rainfall (DECIMAL(10,2))
  - wind_speed (DECIMAL(5,2))
  - wind_direction (VARCHAR(20))

### 8. PestDisease
- **Primary Key**: pest_disease_id (UUID)
- **Attributes**:
  - name (VARCHAR(100))
  - scientific_name (VARCHAR(100))
  - description (TEXT)
  - symptoms (TEXT)
  - treatment_methods (TEXT)
  - severity_level (ENUM: 'LOW', 'MEDIUM', 'HIGH')

### 9. FarmPestDisease
- **Primary Key**: (farm_id, pest_disease_id)
- **Foreign Keys**:
  - farm_id (UUID) REFERENCES Farm(farm_id)
  - pest_disease_id (UUID) REFERENCES PestDisease(pest_disease_id)
- **Attributes**:
  - detection_date (DATE)
  - severity (ENUM: 'LOW', 'MEDIUM', 'HIGH')
  - status (ENUM: 'DETECTED', 'TREATED', 'RESOLVED')
  - treatment_applied (TEXT)

### 10. Resource
- **Primary Key**: resource_id (UUID)
- **Attributes**:
  - name (VARCHAR(100))
  - type (ENUM: 'WATER', 'FERTILIZER', 'PESTICIDE', 'SEED', 'EQUIPMENT')
  - unit (VARCHAR(20))
  - cost_per_unit (DECIMAL(10,2))
  - description (TEXT)

### 11. FarmResource
- **Primary Key**: (farm_id, resource_id)
- **Foreign Keys**:
  - farm_id (UUID) REFERENCES Farm(farm_id)
  - resource_id (UUID) REFERENCES Resource(resource_id)
- **Attributes**:
  - quantity (DECIMAL(10,2))
  - last_updated (TIMESTAMP)
  - minimum_threshold (DECIMAL(10,2))

### 12. Advisory
- **Primary Key**: advisory_id (UUID)
- **Foreign Keys**:
  - created_by (UUID) REFERENCES User(user_id)
  - farm_id (UUID) REFERENCES Farm(farm_id)
- **Attributes**:
  - title (VARCHAR(200))
  - content (TEXT)
  - created_at (TIMESTAMP)
  - priority (ENUM: 'LOW', 'MEDIUM', 'HIGH')
  - status (ENUM: 'DRAFT', 'PUBLISHED', 'ARCHIVED')

### 13. MarketPrice
- **Primary Key**: price_id (UUID)
- **Foreign Key**: crop_id (UUID) REFERENCES Crop(crop_id)
- **Attributes**:
  - price (DECIMAL(10,2))
  - currency (VARCHAR(3))
  - market_location (VARCHAR(100))
  - timestamp (TIMESTAMP)
  - source (VARCHAR(100))

## Relationships and Cardinality

1. User (1) ---< Farm (N)
   - One user can own multiple farms
   - Each farm must have exactly one owner

2. Farm (N) ---< FarmCrop (N) ---> Crop (N)
   - A farm can grow multiple crops
   - A crop can be grown on multiple farms
   - FarmCrop serves as a junction table with additional attributes

3. Farm (1) ---< Sensor (N)
   - A farm can have multiple sensors
   - Each sensor belongs to exactly one farm

4. Sensor (1) ---< SensorReading (N)
   - A sensor can have multiple readings
   - Each reading belongs to exactly one sensor

5. Farm (1) ---< WeatherData (N)
   - A farm can have multiple weather records
   - Each weather record belongs to exactly one farm

6. Farm (N) ---< FarmPestDisease (N) ---> PestDisease (N)
   - A farm can have multiple pest/disease issues
   - A pest/disease can affect multiple farms
   - FarmPestDisease serves as a junction table with additional attributes

7. Farm (N) ---< FarmResource (N) ---> Resource (N)
   - A farm can have multiple resources
   - A resource can be used by multiple farms
   - FarmResource serves as a junction table with additional attributes

8. User (1) ---< Advisory (N) ---> Farm (N)
   - A user can create multiple advisories
   - An advisory can be associated with multiple farms
   - Each advisory must have exactly one creator

9. Crop (1) ---< MarketPrice (N)
   - A crop can have multiple market prices
   - Each market price belongs to exactly one crop

## Business Rules and Constraints

1. **User Management**:
   - Email addresses must be unique and valid
   - Passwords must be hashed before storage
   - User status must be tracked

2. **Farm Management**:
   - Farm location must be within valid coordinates
   - Farm area must be greater than 0
   - Farm status must be tracked

3. **Crop Management**:
   - Planting date must be before expected harvest date
   - Actual harvest date cannot be before planting date
   - Yield must be non-negative

4. **Sensor Management**:
   - Sensor readings must be within valid ranges
   - Sensor status must be tracked
   - Maintenance schedule must be maintained

5. **Resource Management**:
   - Resource quantities cannot be negative
   - Minimum thresholds must be set for critical resources
   - Resource updates must be timestamped

6. **Pest and Disease Management**:
   - Detection date must be before or equal to current date
   - Treatment status must be tracked
   - Severity levels must be standardized

7. **Market Price Management**:
   - Prices must be non-negative
   - Currency must be valid
   - Timestamps must be accurate

8. **Advisory Management**:
   - Advisories must have a creator
   - Priority levels must be standardized
   - Status transitions must be valid

## Indexes and Performance Considerations

1. **Primary Indexes**:
   - All primary keys
   - User email and username
   - Farm location (spatial index)
   - Sensor readings timestamp
   - Market prices timestamp

2. **Secondary Indexes**:
   - Farm status
   - Crop status
   - Sensor status
   - Advisory priority
   - Resource thresholds

## Data Integrity Rules

1. **Referential Integrity**:
   - All foreign keys must reference existing primary keys
   - Cascade delete rules for dependent entities
   - Restrict delete rules for critical entities

2. **Domain Integrity**:
   - Enumerated types must use predefined values
   - Numeric values must be within valid ranges
   - Dates must be valid and logical

3. **Entity Integrity**:
   - Primary keys must be unique and non-null
   - Required attributes must not be null
   - Unique constraints must be enforced 