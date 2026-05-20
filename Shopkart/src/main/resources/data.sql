-- Seed data loaded after Hibernate builds the schema (see application.properties: defer-datasource-initialization).
-- Demo passwords: plain text is "password" for both customer and admin (BCrypt via Spring-compatible hash).
-- Admin login also requires security key: admin-secret-key

INSERT INTO customer (name, email, password, address, phone, profile_pic, signup_date, last_login_date) VALUES
('Demo User', 'user@shopkart.local', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', '1 Demo Street, Sample City', 9876543210, NULL, CURRENT_TIMESTAMP, NULL);

INSERT INTO shop_admin (username, password, email, security_key) VALUES
('admin', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'admin@shopkart.local', 'admin-secret-key');

INSERT INTO product (name, category, brand, price, image, stock, discount) VALUES
('Wireless Headphones', 'Electronics', 'SoundMax', 2499.00, 'headphone.jpg', 40, 10.0),
('Stainless Steel Bottle', 'Home', 'HydroLife', 799.00, 'water-bottle.jpg', 120, 0.0),
('Running Shoes', 'Fashion', 'Stride', 3499.00, 'shoes.jpg', 25, 15.0);
