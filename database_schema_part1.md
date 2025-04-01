# Smart Agriculture Database System - Enhanced Entity-Relationship Model (Part 1)

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