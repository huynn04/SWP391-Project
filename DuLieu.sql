
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


-- Thêm dữ liệu vào bảng `products` với đường dẫn hình ảnh
INSERT INTO products (category_id, product_name, detail_desc, image, price, quantity)
VALUES 
    (1, 'Naruto Figure', 'A detailed Naruto figure with swirling elemental effects.', '/image/cuuvi.jpg', 100.00, 6),
    (2, 'Charizard Figure', 'A Charizard collectible figure with flame effects.', '/image/charizaRDY.jpg', 35.99, 10),
	(2, 'Ash Greninja Figure', 'A highly detailed Greninja figure from Pokémon.', '/image/greninja2.jpg', 25.99, 8),
    (3, 'Strike Freedom Gundam', 'A Gundam model with stunning gold and blue details.', '/image/gundam1.jpg', 150.00, 5);

	-- Thêm dữ liệu vào bảng `users` (Dữ liệu cơ bản cho các người dùng)
INSERT INTO users (role_id, full_name, email, password, phone_number, address, avatar, status)
VALUES

    (1, 'Admin User', 'admin@example.com', 'admin', '1234567890', 'Vinh Long', NULL, 1),
    (2, 'Staff User', 'staff@example.com', '123456', '0987654321', 'Ben Tre', NULL, 1),
    (3, 'Normal User', 'user@example.com', '123456', '0123456789', 'Bac Lieu', NULL, 1),
	(3, 'Alice Johnson', 'alice@example.com', 'alice123', '1112223333', 'Ho Chi Minh', NULL, 1),
    (3, 'Bob Smith', 'bob@example.com', 'bob123', '2223334444', 'Ha Noi', NULL, 1),
    (3, 'Carol Lee', 'carol@example.com', 'carol123', '3334445555', 'Da Nang', NULL, 1);
-- Thêm dữ liệu vào bảng `cart`
INSERT INTO cart (user_id)
VALUES
    ((SELECT user_id FROM users WHERE email = 'admin@example.com')),
    ((SELECT user_id FROM users WHERE email = 'staff@example.com')),
    ((SELECT user_id FROM users WHERE email = 'user@example.com'));

	-- INSERT DATA VÀO BẢNG orders
INSERT INTO orders (user_id, total_price, note, receiver_name, receiver_address, receiver_phone, payment_method, discount_code)
VALUES 
    (
        (SELECT user_id FROM users WHERE email = 'user@example.com'),
        200.00,
        'Please deliver ASAP.',
        'Normal User',
        'Bac Lieu',
        '0123456789',
        'COD',
        NULL
    ),
    (
        (SELECT user_id FROM users WHERE email = 'staff@example.com'),
        300.00,
        'Call before delivery.',
        'Staff User',
        'Ben Tre',
        '0987654321',
        'COD',
        'DISCOUNT5'
    );

-- INSERT DATA VÀO BẢNG order_details
-- Giả sử đơn hàng đầu tiên ( của Normal User ) có 2 mặt hàng:
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal, tax)
VALUES
    (
        (SELECT TOP 1 order_id FROM orders WHERE user_id = (SELECT user_id FROM users WHERE email = 'user@example.com') ORDER BY order_date DESC),
        (SELECT product_id FROM products WHERE product_name = 'Naruto Figure'),
        2, -- số lượng 2
        100.00, -- đơn giá
        200.00, -- subtotal = 2 * 100.00
        10.00   -- thuế (ví dụ)
    ),
    (
        (SELECT TOP 1 order_id FROM orders WHERE user_id = (SELECT user_id FROM users WHERE email = 'user@example.com') ORDER BY order_date DESC),
        (SELECT product_id FROM products WHERE product_name = 'Charizard Figure'),
        1,
        35.99,
        35.99,
        2.00
    );

-- Giả sử đơn hàng thứ hai ( của Staff User ) có 1 mặt hàng:
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal, tax)
VALUES
    (
        (SELECT TOP 1 order_id FROM orders WHERE user_id = (SELECT user_id FROM users WHERE email = 'staff@example.com') ORDER BY order_date DESC),
        (SELECT product_id FROM products WHERE product_name = 'Strike Freedom Gundam'),
        1,
        150.00,
        150.00,
        7.50
    );

SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM roles;
SELECT * FROM cart;

SELECT * FROM  users;