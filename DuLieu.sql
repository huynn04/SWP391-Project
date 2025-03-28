USE [ShopFMSOS]
GO
SET IDENTITY_INSERT [dbo].[roles] ON 

INSERT [dbo].[roles] ([role_id], [role_name], [description]) VALUES (1, N'admin', N'Administrator with full access to the system')
INSERT [dbo].[roles] ([role_id], [role_name], [description]) VALUES (2, N'staff', N'Staff with limited access to manage the shop')
INSERT [dbo].[roles] ([role_id], [role_name], [description]) VALUES (3, N'customer', N'Registered user with the ability to browse and purchase products')
INSERT [dbo].[roles] ([role_id], [role_name], [description]) VALUES (4, N'guest', N'Unregistered user with limited browsing access')
SET IDENTITY_INSERT [dbo].[roles] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [role_id], [full_name], [email], [phone_number], [address], [password], [avatar], [status], [created_at], [updated_at]) VALUES (1, 1, N'Admin User', N'admin@example.com', N'1234567890', N'123 Admin Street', N'admin', N'image/HuynhDat.jpg', 1, CAST(N'2025-03-24T10:28:20.800' AS DateTime), CAST(N'2025-03-24T18:57:22.323' AS DateTime))
INSERT [dbo].[users] ([user_id], [role_id], [full_name], [email], [phone_number], [address], [password], [avatar], [status], [created_at], [updated_at]) VALUES (2, 2, N'Staff User', N'staff@example.com', N'0987654321', N'456 Staff Road', N'123456', NULL, 1, CAST(N'2025-03-24T10:28:20.800' AS DateTime), CAST(N'2025-03-24T10:28:20.800' AS DateTime))
INSERT [dbo].[users] ([user_id], [role_id], [full_name], [email], [phone_number], [address], [password], [avatar], [status], [created_at], [updated_at]) VALUES (3, 3, N'Customer User', N'customer@example.com', N'1122334455', N'789 Customer Ave', N'123456', N'/image/HuynhDat.jpg', 1, CAST(N'2025-03-24T10:28:20.800' AS DateTime), CAST(N'2025-03-24T11:27:00.043' AS DateTime))
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET IDENTITY_INSERT [dbo].[categories] ON 

INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (1, N'Anime', N'Figures and merchandise from various anime series', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (2, N'Pokemon', N'Figures and collectibles from the Pokémon universe', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (3, N'Gundam', N'Scale models and figures from the Gundam franchise', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (4, N'One Piece', N'Figures and collectibles from the One Piece universe', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (5, N'Marvel', N'Superhero figures and merchandise from the Marvel universe', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (6, N'DC Comics', N'Figures and collectibles featuring DC superheroes and villains', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (7, N'Star Wars', N'Action figures, models, and memorabilia from Star Wars', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (8, N'Dragon Ball', N'Figures and collectibles from the Dragon Ball series', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (9, N'Naruto', N'Figures and merchandise from the Naruto anime and manga', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (10, N'Demon Slayer', N'Figures and merchandise from Kimetsu no Yaiba (Demon Slayer)', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (11, N'Video Games', N'Figures and collectibles from popular video games', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[categories] ([category_id], [category_name], [description], [image], [status], [created_at], [updated_at]) VALUES (12, N'Harry Potter', N'Magical collectibles and figures from the Harry Potter universe', NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
SET IDENTITY_INSERT [dbo].[categories] OFF
GO
SET IDENTITY_INSERT [dbo].[products] ON 

INSERT [dbo].[products] ([product_id], [category_id], [product_name], [detail_desc], [image], [price], [discount], [quantity], [sold], [target], [factory], [status], [created_at], [updated_at]) VALUES (1, 1, N'Naruto Figure', N'A detailed Naruto figure with swirling elemental effects.', N'/image/cuuvi.jpg', CAST(100.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(5, 2)), 14, 7, NULL, NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T11:39:36.023' AS DateTime))
INSERT [dbo].[products] ([product_id], [category_id], [product_name], [detail_desc], [image], [price], [discount], [quantity], [sold], [target], [factory], [status], [created_at], [updated_at]) VALUES (2, 2, N'Charizard Figure', N'A Charizard collectible figure with flame effects.', N'/image/charizaRDY.jpg', CAST(35.99 AS Decimal(10, 2)), CAST(0.00 AS Decimal(5, 2)), 3, 7, NULL, NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[products] ([product_id], [category_id], [product_name], [detail_desc], [image], [price], [discount], [quantity], [sold], [target], [factory], [status], [created_at], [updated_at]) VALUES (3, 2, N'Ash Greninja Figure', N'A highly detailed Greninja figure from Pokémon.', N'/image/greninja2.jpg', CAST(25.99 AS Decimal(10, 2)), CAST(0.00 AS Decimal(5, 2)), 6, 2, NULL, NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
INSERT [dbo].[products] ([product_id], [category_id], [product_name], [detail_desc], [image], [price], [discount], [quantity], [sold], [target], [factory], [status], [created_at], [updated_at]) VALUES (4, 3, N'Strike Freedom Gundam', N'A Gundam model with stunning gold and blue details.', N'/image/gundam1.jpg', CAST(150.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(5, 2)), 4, 1, NULL, NULL, 1, CAST(N'2025-03-24T10:45:25.860' AS DateTime), CAST(N'2025-03-24T10:45:25.860' AS DateTime))
SET IDENTITY_INSERT [dbo].[products] OFF
GO
SET IDENTITY_INSERT [dbo].[discounts] ON 

INSERT [dbo].[discounts] ([discount_id], [code], [discount_value], [discount_type], [min_order_value], [expiry_date], [status]) VALUES (1, N'SALE10', CAST(10.00 AS Decimal(10, 2)), N'percent', CAST(100.00 AS Decimal(10, 2)), CAST(N'2025-12-31' AS Date), 1)
INSERT [dbo].[discounts] ([discount_id], [code], [discount_value], [discount_type], [min_order_value], [expiry_date], [status]) VALUES (2, N'FIXED50', CAST(50.00 AS Decimal(10, 2)), N'fixed', CAST(200.00 AS Decimal(10, 2)), CAST(N'2025-06-30' AS Date), 1)
INSERT [dbo].[discounts] ([discount_id], [code], [discount_value], [discount_type], [min_order_value], [expiry_date], [status]) VALUES (3, N'FREESHIP', CAST(30.00 AS Decimal(10, 2)), N'fixed', CAST(150.00 AS Decimal(10, 2)), CAST(N'2025-09-30' AS Date), 1)
SET IDENTITY_INSERT [dbo].[discounts] OFF
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (2, 3, CAST(105.00 AS Decimal(10, 2)), CAST(N'2025-03-24T10:49:16.077' AS DateTime), 2, NULL, N'Hu?nh Ð?t6', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (3, 3, CAST(480.00 AS Decimal(10, 2)), CAST(N'2025-03-24T11:08:34.877' AS DateTime), -1, NULL, N'Hu?nh Ð?t', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'Online', NULL, NULL, CAST(N'2025-03-24T11:37:38.973' AS DateTime), NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (4, 3, CAST(37.79 AS Decimal(10, 2)), CAST(N'2025-03-24T11:31:39.663' AS DateTime), -1, NULL, N'Hu?nh Ð?t6', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, CAST(N'2025-03-24T11:37:42.780' AS DateTime), NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (5, 3, CAST(65.08 AS Decimal(10, 2)), CAST(N'2025-03-24T11:31:52.170' AS DateTime), -1, NULL, N'Hu?nh Ð?t6', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, CAST(N'2025-03-24T11:37:44.240' AS DateTime), NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (6, 3, CAST(142.79 AS Decimal(10, 2)), CAST(N'2025-03-24T11:32:17.547' AS DateTime), -1, NULL, N'Hu?nh Ð?t6', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, CAST(N'2025-03-24T11:37:45.213' AS DateTime), NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (7, 3, CAST(124.17 AS Decimal(10, 2)), CAST(N'2025-03-24T11:39:05.603' AS DateTime), 2, NULL, N'Hu?nh Ð?t', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (8, 1, CAST(27.29 AS Decimal(10, 2)), CAST(N'2025-03-24T21:21:09.907' AS DateTime), 2, NULL, N'Hu?nh Ð?t6', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (9, 3, CAST(157.50 AS Decimal(10, 2)), CAST(N'2025-03-24T21:24:25.057' AS DateTime), 2, NULL, N'Ab', N'Kien Giang, Vinh Long, Trà Ôn, Vinh Long', N'0977658112', N'COD', NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (10, 3, CAST(105.00 AS Decimal(10, 2)), CAST(N'2025-03-24T22:11:59.130' AS DateTime), 0, NULL, N'Tran Huy Lam', N'20/10 Nguyen Trai, Cai Khe, Ninh Kieu, Cai Khe', N'0856021732', N'COD', NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[orders] ([order_id], [user_id], [total_price], [order_date], [status], [note], [receiver_name], [receiver_address], [receiver_phone], [payment_method], [discount_code], [delivered_at], [canceled_at], [discount_id], [discount_amount]) VALUES (11, 3, CAST(0.00 AS Decimal(10, 2)), CAST(N'2025-03-25T00:02:05.517' AS DateTime), 0, NULL, N'Tran Huy Lam', N'20/10 Nguyen Trai, Cai Khe, Ninh Kieu, Cai Khe', N'0856021732', N'COD', NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[news] ON 

INSERT [dbo].[news] ([news_id], [user_id], [title], [content], [image], [status], [created_at], [updated_at]) VALUES (16, 1, N'Shop New Launch', N'<p>We are excited to launch our new online store!</p>', N'/image/gundam4.jpg', 1, CAST(N'2025-03-24T02:25:15.290' AS DateTime), CAST(N'2025-03-24T10:16:23.240' AS DateTime))
INSERT [dbo].[news] ([news_id], [user_id], [title], [content], [image], [status], [created_at], [updated_at]) VALUES (17, 1, N'Holiday Sale', N'<p>Our big holiday sale is live now!</p>', N'/image/gundam.jpg', 1, CAST(N'2025-03-24T02:25:15.290' AS DateTime), CAST(N'2025-03-24T10:16:37.440' AS DateTime))
INSERT [dbo].[news] ([news_id], [user_id], [title], [content], [image], [status], [created_at], [updated_at]) VALUES (18, 1, N'Shop New Launch', N'<p>We are excited to launch our new online store!</p>', N'/image/gundam2.jpg', 1, CAST(N'2025-03-24T02:26:35.237' AS DateTime), CAST(N'2025-03-24T10:16:10.137' AS DateTime))
INSERT [dbo].[news] ([news_id], [user_id], [title], [content], [image], [status], [created_at], [updated_at]) VALUES (19, 1, N'Holiday Sale', N'<p>Our big holiday sale is live now!</p>', N'/image/gundam3.jpg', 1, CAST(N'2025-03-24T02:26:35.237' AS DateTime), CAST(N'2025-03-24T10:16:17.083' AS DateTime))
INSERT [dbo].[news] ([news_id], [user_id], [title], [content], [image], [status], [created_at], [updated_at]) VALUES (20, 1, N'Shop New Launch', N'<p>We are excited to launch our new online store!</p>', N'/image/charixardx.png', 1, CAST(N'2025-03-24T02:27:43.543' AS DateTime), CAST(N'2025-03-24T10:15:55.300' AS DateTime))
INSERT [dbo].[news] ([news_id], [user_id], [title], [content], [image], [status], [created_at], [updated_at]) VALUES (21, 1, N'Holiday Sale', N'<p>Our big holiday sale is live now!</p>', N'/image/gundam1.jpg', 1, CAST(N'2025-03-24T02:27:43.543' AS DateTime), CAST(N'2025-03-24T10:16:04.590' AS DateTime))
SET IDENTITY_INSERT [dbo].[news] OFF
GO
SET IDENTITY_INSERT [dbo].[news_comments] ON 

INSERT [dbo].[news_comments] ([comment_id], [news_id], [user_id], [content], [created_at], [updated_at]) VALUES (13, 16, 1, N'Congratulations on the new launch!', CAST(N'2025-03-24T02:31:58.733' AS DateTime), CAST(N'2025-03-24T02:31:58.733' AS DateTime))
INSERT [dbo].[news_comments] ([comment_id], [news_id], [user_id], [content], [created_at], [updated_at]) VALUES (14, 17, 2, N'I am looking forward to the sale!', CAST(N'2025-03-24T02:31:58.733' AS DateTime), CAST(N'2025-03-24T02:31:58.733' AS DateTime))
INSERT [dbo].[news_comments] ([comment_id], [news_id], [user_id], [content], [created_at], [updated_at]) VALUES (16, 21, 3, N's', CAST(N'2025-03-24T11:15:15.690' AS DateTime), CAST(N'2025-03-24T11:15:15.690' AS DateTime))
INSERT [dbo].[news_comments] ([comment_id], [news_id], [user_id], [content], [created_at], [updated_at]) VALUES (17, 20, 1, N'Very nice product, as described !!!', CAST(N'2025-03-24T11:15:33.777' AS DateTime), CAST(N'2025-03-24T11:20:00.833' AS DateTime))
SET IDENTITY_INSERT [dbo].[news_comments] OFF
GO
SET IDENTITY_INSERT [dbo].[order_details] ON 

INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (3, 2, 1, 1, CAST(100.00 AS Decimal(10, 2)), CAST(100.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (4, 3, 1, 4, CAST(100.00 AS Decimal(10, 2)), CAST(400.00 AS Decimal(10, 2)), CAST(20.00 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (5, 4, 2, 1, CAST(35.99 AS Decimal(10, 2)), CAST(35.99 AS Decimal(10, 2)), CAST(1.80 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (6, 5, 2, 1, CAST(35.99 AS Decimal(10, 2)), CAST(35.99 AS Decimal(10, 2)), CAST(1.80 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (7, 5, 3, 1, CAST(25.99 AS Decimal(10, 2)), CAST(25.99 AS Decimal(10, 2)), CAST(1.30 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (8, 6, 1, 1, CAST(100.00 AS Decimal(10, 2)), CAST(100.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (9, 6, 2, 1, CAST(35.99 AS Decimal(10, 2)), CAST(35.99 AS Decimal(10, 2)), CAST(1.80 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (10, 7, 2, 3, CAST(35.99 AS Decimal(10, 2)), CAST(107.97 AS Decimal(10, 2)), CAST(5.40 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (11, 8, 3, 1, CAST(25.99 AS Decimal(10, 2)), CAST(25.99 AS Decimal(10, 2)), CAST(1.30 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (12, 9, 4, 1, CAST(150.00 AS Decimal(10, 2)), CAST(150.00 AS Decimal(10, 2)), CAST(7.50 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (13, 10, 1, 1, CAST(100.00 AS Decimal(10, 2)), CAST(100.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(5, 2)))
INSERT [dbo].[order_details] ([order_detail_id], [order_id], [product_id], [quantity], [price], [subtotal], [tax]) VALUES (14, 11, 2, 1, CAST(35.99 AS Decimal(10, 2)), CAST(35.99 AS Decimal(10, 2)), CAST(1.80 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[order_details] OFF
GO
SET IDENTITY_INSERT [dbo].[product_reviews] ON 

INSERT [dbo].[product_reviews] ([review_id], [order_detail_id], [product_id], [user_id], [review_content], [rating], [status], [created_at], [updated_at]) VALUES (2, 3, 1, 2, N'Great product, highly recommend!', 3, 1, CAST(N'2025-03-24T12:18:12.080' AS DateTime), CAST(N'2025-03-24T12:18:12.080' AS DateTime))
SET IDENTITY_INSERT [dbo].[product_reviews] OFF
GO
