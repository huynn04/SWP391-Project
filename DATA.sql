GO
CREATE DATABASE ShopFMSOS;
GO
USE ShopFMSOS;
GO

-- Tạo bảng roles
CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(MAX)
);

-- Insert các vai trò mặc định
INSERT INTO roles (role_name, description)
VALUES 
    ('admin', 'Administrator with full access to the system'),
    ('staff', 'Staff with limited access to manage the shop'),
    ('customer', 'Registered user with the ability to browse and purchase products'),
    ('guest', 'Unregistered user with limited browsing access');

-- Tạo bảng users
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    role_id INT NOT NULL DEFAULT 3,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    address VARCHAR(MAX),
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Tạo bảng categories
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    description VARCHAR(MAX),
    image VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Tạo bảng products
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    detail_desc VARCHAR(MAX),
    image VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    quantity INT NOT NULL,
    sold INT DEFAULT 0,
    target VARCHAR(255),
    factory VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Tạo bảng cart
CREATE TABLE cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng cart_details
CREATE TABLE cart_details (
    cart_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    status SMALLINT DEFAULT 0,
    note VARCHAR(MAX),
    receiver_name VARCHAR(255) NOT NULL,
    receiver_address VARCHAR(MAX) NOT NULL,
    receiver_phone VARCHAR(15) NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'COD',
    discount_code VARCHAR(50),
    delivered_at DATETIME NULL,
    canceled_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng order_details
CREATE TABLE order_details (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Tạo bảng product_reviews
CREATE TABLE product_reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    order_detail_id INT NOT NULL,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    review_content VARCHAR(MAX),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    likes INT DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_detail_id) REFERENCES order_details(order_detail_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng news
CREATE TABLE news (
    news_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content VARCHAR(MAX) NOT NULL,
    image VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng news_comments
CREATE TABLE news_comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    news_id INT NOT NULL,
    user_id INT NOT NULL,
    content VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (news_id) REFERENCES news(news_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

GO
