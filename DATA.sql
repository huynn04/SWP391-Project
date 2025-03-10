-- Thêm dữ liệu vào bảng `categories`
INSERT INTO categories (category_name, description)
VALUES 
    ('Anime', 'Figures and merchandise from various anime series'),
    ('Pokemon', 'Figures and collectibles from the Pokémon universe'),
    ('Gundam', 'Scale models and figures from the Gundam franchise'),
    ('One Piece', 'Figures and collectibles from the One Piece universe'),
    ('Marvel', 'Superhero figures and merchandise from the Marvel universe'),
    ('DC Comics', 'Figures and collectibles featuring DC superheroes and villains'),
    ('Star Wars', 'Action figures, models, and memorabilia from Star Wars'),
    ('Dragon Ball', 'Figures and collectibles from the Dragon Ball series'),
    ('Naruto', 'Figures and merchandise from the Naruto anime and manga'),
    ('Demon Slayer', 'Figures and merchandise from Kimetsu no Yaiba (Demon Slayer)'),
    ('Video Games', 'Figures and collectibles from popular video games'),
    ('Harry Potter', 'Magical collectibles and figures from the Harry Potter universe');

-- Thêm dữ liệu vào bảng `products`
INSERT INTO products (category_id, product_name, detail_desc, image, price, quantity)
VALUES 
    (1, 'Naruto Figure', 'A detailed Naruto figure with swirling elemental effects.', '/image/cuuvi.jpg', 100.00, 6),
    (2, 'Charizard Figure', 'A Charizard collectible figure with flame effects.', '/image/charizaRDY.jpg', 35.99, 10),
    (2, 'Ash Greninja Figure', 'A highly detailed Greninja figure from Pokémon.', '/image/greninja2.jpg', 25.99, 8),
    (3, 'Strike Freedom Gundam', 'A Gundam model with stunning gold and blue details.', '/image/gundam1.jpg', 150.00, 5);

-- Thêm dữ liệu vào bảng `users`
INSERT INTO users (role_id, full_name, email, password, phone_number, avatar, status)
VALUES 
    (1, 'Admin User', 'admin@example.com', 'admin', '1234567890', NULL, 1),
    (2, 'Staff User', 'staff@example.com', '123456', '0987654321', NULL, 1),
    (3, 'Normal User', 'user@example.com', '123456', '0123456789', NULL, 1),
    (3, 'Alice Johnson', 'alice@example.com', 'alice123', '1112223333', NULL, 1),
    (3, 'Bob Smith', 'bob@example.com', 'bob123', '2223334444', NULL, 1),
    (3, 'Carol Lee', 'carol@example.com', 'carol123', '3334445555', NULL, 1);

-- Thêm địa chỉ cho từng user vào bảng `addresses`
INSERT INTO addresses (user_id, full_name, phone, city, district, ward, specific_address, address_type, is_default)
VALUES 
    ((SELECT user_id FROM users WHERE email = 'admin@example.com'), 'Admin User', '1234567890', 'Vinh Long', 'Long Ho', 'Ward 1', '123 Main St', 'home', 1),
    ((SELECT user_id FROM users WHERE email = 'staff@example.com'), 'Staff User', '0987654321', 'Ben Tre', 'Mo Cay', 'Ward 2', '456 Street Ave', 'home', 1),
    ((SELECT user_id FROM users WHERE email = 'user@example.com'), 'Normal User', '0123456789', 'Bac Lieu', 'Gia Rai', 'Ward 3', '789 House Lane', 'home', 1),
    ((SELECT user_id FROM users WHERE email = 'alice@example.com'), 'Alice Johnson', '1112223333', 'Ho Chi Minh', 'District 1', 'Ward 5', '101 Alice St', 'home', 1),
    ((SELECT user_id FROM users WHERE email = 'bob@example.com'), 'Bob Smith', '2223334444', 'Ha Noi', 'Ba Dinh', 'Ward 8', '202 Bob Ave', 'home', 1),
    ((SELECT user_id FROM users WHERE email = 'carol@example.com'), 'Carol Lee', '3334445555', 'Da Nang', 'Son Tra', 'Ward 9', '303 Carol Lane', 'home', 1);

-- Cập nhật `address_id` trong bảng `users`
UPDATE users
SET address_id = (SELECT address_id FROM addresses WHERE addresses.user_id = users.user_id AND is_default = 1)
WHERE EXISTS (SELECT 1 FROM addresses WHERE addresses.user_id = users.user_id);

-- Thêm dữ liệu vào bảng `cart`
INSERT INTO cart (user_id)
VALUES
    ((SELECT user_id FROM users WHERE email = 'admin@example.com')),
    ((SELECT user_id FROM users WHERE email = 'staff@example.com')),
    ((SELECT user_id FROM users WHERE email = 'user@example.com'));

-- Thêm dữ liệu vào bảng `orders`
INSERT INTO orders (user_id, total_price, note, receiver_name, receiver_address_id, receiver_phone, payment_method, discount_code)
VALUES 
    (
        (SELECT user_id FROM users WHERE email = 'user@example.com'),
        200.00,
        'Please deliver ASAP.',
        'Normal User',
        (SELECT address_id FROM addresses WHERE user_id = (SELECT user_id FROM users WHERE email = 'user@example.com') AND is_default = 1),
        '0123456789',
        'COD',
        NULL
    ),
    (
        (SELECT user_id FROM users WHERE email = 'staff@example.com'),
        300.00,
        'Call before delivery.',
        'Staff User',
        (SELECT address_id FROM addresses WHERE user_id = (SELECT user_id FROM users WHERE email = 'staff@example.com') AND is_default = 1),
        '0987654321',
        'COD',
        'DISCOUNT5'
    );

-- Thêm dữ liệu vào bảng `order_details`
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal, tax)
VALUES
    (
        (SELECT TOP 1 order_id FROM orders WHERE user_id = (SELECT user_id FROM users WHERE email = 'user@example.com') ORDER BY order_date DESC),
        (SELECT product_id FROM products WHERE product_name = 'Naruto Figure'),
        2,
        100.00,
        200.00,
        10.00
    ),
    (
        (SELECT TOP 1 order_id FROM orders WHERE user_id = (SELECT user_id FROM users WHERE email = 'user@example.com') ORDER BY order_date DESC),
        (SELECT product_id FROM products WHERE product_name = 'Charizard Figure'),
        1,
        35.99,
        35.99,
        2.00
    ),
    (
        (SELECT TOP 1 order_id FROM orders WHERE user_id = (SELECT user_id FROM users WHERE email = 'staff@example.com') ORDER BY order_date DESC),
        (SELECT product_id FROM products WHERE product_name = 'Strike Freedom Gundam'),
        1,
        150.00,
        150.00,
        7.50
    );

-- Kiểm tra dữ liệu sau khi thêm
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM roles;
SELECT * FROM cart;
SELECT * FROM users;
SELECT * FROM addresses;
SELECT * FROM orders;
SELECT * FROM order_details;
