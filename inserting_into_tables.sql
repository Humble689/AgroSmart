-- Insert sample data into Crops table
INSERT INTO Crops (name, category, growth_duration, ideal_conditions) VALUES
('Maize', 'Grains', 90, 'Warm climate, well-drained soil'),
('Tomato', 'Vegetables', 70, 'Moderate temperature, regular watering'),
('Mango', 'Fruits', 120, 'Tropical climate, well-drained soil'),
('Beans', 'Legumes', 60, 'Moderate temperature, regular watering'),
('Cassava', 'Root Crops', 180, 'Warm climate, drought tolerant');

-- Insert sample data into Farmers table
INSERT INTO Farmers (name, location, contact_info, farm_size, registration_date) VALUES
('John Doe', 'Nairobi', '+254712345678', 5.5, '2022-01-15'),
('Jane Smith', 'Kisumu', '+254723456789', 3.2, '2022-03-20'),
('Robert Johnson', 'Mombasa', '+254734567890', 7.8, '2021-11-05'),
('Mary Williams', 'Eldoret', '+254745678901', 4.0, '2022-02-10'),
('James Brown', 'Nakuru', '+254756789012', 6.5, '2021-12-25');

-- Insert sample data into Farms table
INSERT INTO Farms (farmer_id, crop_id, location, size, yield_estimate) VALUES
(1, 1, 'Nairobi West', 2.0, 1500.00),
(1, 2, 'Nairobi East', 1.5, 800.00),
(2, 3, 'Kisumu Central', 1.2, 600.00),
(3, 4, 'Mombasa North', 3.0, 900.00),
(4, 5, 'Eldoret South', 2.5, 1200.00),
(5, 1, 'Nakuru East', 3.0, 1800.00);

-- Insert sample data into Market_Prices table
INSERT INTO Market_Prices (crop_id, location, price_per_kg, date_recorded) VALUES
(1, 'Nairobi', 50.00, '2023-01-10'),
(2, 'Nairobi', 80.00, '2023-01-10'),
(3, 'Kisumu', 120.00, '2023-01-10'),
(4, 'Mombasa', 60.00, '2023-01-10'),
(5, 'Eldoret', 40.00, '2023-01-10'),
(1, 'Nairobi', 55.00, '2023-02-15'),
(2, 'Nairobi', 85.00, '2023-02-15');

-- Insert sample data into Weather_Data table
INSERT INTO Weather_Data (location, temperature, rainfall, humidity, date_recorded) VALUES
('Nairobi', 25.5, 10.2, 65.0, '2023-01-10'),
('Kisumu', 28.0, 15.5, 70.0, '2023-01-10'),
('Mombasa', 30.5, 20.0, 80.0, '2023-01-10'),
('Eldoret', 22.0, 8.5, 60.0, '2023-01-10'),
('Nakuru', 24.0, 12.0, 65.0, '2023-01-10');

-- Insert sample data into Supply_Chain_Distribution table
INSERT INTO Supply_Chain_Distribution (crop_id, farmer_id, buyer_name, quantity, price_sold, date_of_sale) VALUES
(1, 1, 'Nairobi Fresh Produce', 1000.00, 45.00, '2023-01-15'),
(2, 1, 'Nairobi Fresh Produce', 500.00, 75.00, '2023-01-15'),
(3, 2, 'Kisumu Fruits Ltd', 400.00, 110.00, '2023-01-16'),
(4, 3, 'Mombasa Legumes Co', 600.00, 55.00, '2023-01-17'),
(5, 4, 'Eldoret Roots Distributors', 800.00, 38.00, '2023-01-18'),
(1, 5, 'Nakuru Grains Inc', 1200.00, 48.00, '2023-01-19');
