USE ShopFMSOS;
GO

-- Kiểm tra và tạo bảng discounts nếu chưa có
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='discounts' AND xtype='U')
BEGIN
    CREATE TABLE discounts (
        discount_id INT IDENTITY(1,1) PRIMARY KEY,
        code VARCHAR(50) UNIQUE NOT NULL,
        discount_value DECIMAL(10,2) NOT NULL,
        discount_type VARCHAR(10) CHECK (discount_type IN ('percent', 'fixed')),
        min_order_value DECIMAL(10,2) DEFAULT 0,
        expiry_date DATE NOT NULL,
        status SMALLINT DEFAULT 1
    );
END

-- Kiểm tra và thêm cột discount_id vào bảng orders nếu chưa có
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders' AND COLUMN_NAME = 'discount_id')
BEGIN
    ALTER TABLE orders ADD discount_id INT NULL;
    ALTER TABLE orders ADD discount_amount DECIMAL(10,2) DEFAULT 0;
    ALTER TABLE orders ADD CONSTRAINT FK_orders_discounts FOREIGN KEY (discount_id) REFERENCES discounts(discount_id);
END

-- Thêm dữ liệu mẫu nếu chưa có
IF NOT EXISTS (SELECT * FROM discounts WHERE code = 'SALE10')
BEGIN
    INSERT INTO discounts (code, discount_value, discount_type, min_order_value, expiry_date, status)
    VALUES 
        ('SALE10', 10, 'percent', 100, '2025-12-31', 1), 
        ('FIXED50', 50, 'fixed', 200, '2025-06-30', 1),
        ('FREESHIP', 30, 'fixed', 150, '2025-09-30', 1);
END
GO
