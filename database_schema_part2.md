# Smart Agriculture Database System - Enhanced Entity-Relationship Model (Part 2)

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