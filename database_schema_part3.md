# Smart Agriculture Database System - Enhanced Entity-Relationship Model (Part 3)

## Remaining Relationships and Cardinality

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
   - User type must be one of the predefined values

2. **Farm Management**:
   - Farm location must be within valid coordinates
   - Farm area must be greater than 0
   - Farm status must be tracked
   - Each farm must have at least one crop or sensor

3. **Crop Management**:
   - Planting date must be before expected harvest date
   - Actual harvest date cannot be before planting date
   - Yield must be non-negative
   - Crop status must follow the defined lifecycle

4. **Sensor Management**:
   - Sensor readings must be within valid ranges
   - Sensor status must be tracked
   - Maintenance schedule must be maintained
   - Each sensor must have at least one reading per day

5. **Resource Management**:
   - Resource quantities cannot be negative
   - Minimum thresholds must be set for critical resources
   - Resource updates must be timestamped
   - Cost per unit must be non-negative

6. **Pest and Disease Management**:
   - Detection date must be before or equal to current date
   - Treatment status must be tracked
   - Severity levels must be standardized
   - Treatment methods must be documented

7. **Market Price Management**:
   - Prices must be non-negative
   - Currency must be valid
   - Timestamps must be accurate
   - Market location must be specified

8. **Advisory Management**:
   - Advisories must have a creator
   - Priority levels must be standardized
   - Status transitions must be valid
   - Content must not be empty

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
   - No orphaned records allowed

2. **Domain Integrity**:
   - Enumerated types must use predefined values
   - Numeric values must be within valid ranges
   - Dates must be valid and logical
   - Text fields must not exceed maximum lengths

3. **Entity Integrity**:
   - Primary keys must be unique and non-null
   - Required attributes must not be null
   - Unique constraints must be enforced
   - Composite keys must be properly defined

## Additional Considerations

1. **Data Archival**:
   - Historical data retention policies
   - Archive tables for old records
   - Data compression for long-term storage

2. **Audit Trail**:
   - Track all data modifications
   - Record user actions
   - Maintain change history

3. **Security**:
   - Role-based access control
   - Data encryption at rest
   - Secure data transmission
   - Regular security audits

4. **Performance Optimization**:
   - Partitioning for large tables
   - Materialized views for reports
   - Query optimization
   - Connection pooling 