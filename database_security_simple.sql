-- Smart Agriculture Database System - Basic Security

-- Create basic roles
CREATE ROLE admin_role;
CREATE ROLE farmer_role;
CREATE ROLE extension_officer_role;

-- Create basic views
CREATE VIEW FarmerView AS
SELECT farm_id, farm_name, location, size_hectares, status
FROM Farms
WHERE owner_id = current_user;

CREATE VIEW ExtensionOfficerView AS
SELECT a.advisory_id, f.farm_name, a.title, a.content, a.created_at
FROM Advisories a
JOIN Farms f ON a.farm_id = f.farm_id;

-- Create basic procedures
CREATE OR REPLACE PROCEDURE add_farm(
    p_farm_name VARCHAR,
    p_location VARCHAR,
    p_size_hectares DECIMAL
) AS $$
BEGIN
    INSERT INTO Farms (farm_name, location, size_hectares, owner_id)
    VALUES (p_farm_name, p_location, p_size_hectares, current_user);
END;
$$ LANGUAGE plpgsql;

-- Create basic trigger
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_farm_timestamp
    BEFORE UPDATE ON Farms
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- Grant basic privileges
GRANT ALL PRIVILEGES ON ALL TABLES TO admin_role;
GRANT SELECT ON FarmerView TO farmer_role;
GRANT EXECUTE ON PROCEDURE add_farm TO farmer_role;
GRANT SELECT ON ExtensionOfficerView TO extension_officer_role;

-- Create basic permission check
CREATE OR REPLACE FUNCTION check_user_permission(
    p_user_id INTEGER,
    p_farm_id INTEGER
) RETURNS BOOLEAN AS $$
BEGIN
    -- Admin has all permissions
    IF EXISTS (
        SELECT 1 FROM UserRoles 
        WHERE user_id = p_user_id AND role_name = 'admin_role'
    ) THEN
        RETURN TRUE;
    END IF;

    -- Farmer can only access their own farm
    IF EXISTS (
        SELECT 1 FROM Farms 
        WHERE farm_id = p_farm_id AND owner_id = p_user_id
    ) THEN
        RETURN TRUE;
    END IF;

    -- Extension officer can view all farms
    IF EXISTS (
        SELECT 1 FROM UserRoles 
        WHERE user_id = p_user_id AND role_name = 'extension_officer_role'
    ) THEN
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
$$ LANGUAGE plpgsql; 