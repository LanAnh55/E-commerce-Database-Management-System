# E-commerce-Database-Management-System

## Project Overview
This project presents the implementation of a robust and scalable **relational database** designed for an e-commerce platform using **Microsoft SQL Management Server**. The system supports essential online retail operations including **product management, customer profiles, order tracking, and multi-method payment processing**. Built with a focus on data integrity and scalability, it serves as a backbone for efficient and secure e-commerce functionality.

## Objective
The **goal** of this database system is to provide a **centralized and optimized** solution that handles the complete lifecycle of an e-commerce business. It ensures that **product** details, **inventory** levels, **user** interactions, and **payment** activities are seamlessly managed in a structured, query-efficient environment.

## Key Features
The database supports comprehensive product **cataloging**, enabling dynamic tracking of inventory, prices, descriptions, and categorization. Customers are managed with complete profile details, including contact information, transaction history, and preferences such as wishlists and reviews.

A highlight of the system is its ability to process flexible payment options. Users can pay using credit cards, gift cards, or even a combination of both. Each transaction is securely stored with relevant flags and metadata, ensuring compliance and traceability.

The **order processing workflow** is tightly integrated with shipping information. From order placement to fulfillment, each step is logged and accessible, ensuring timely deliveries and operational transparency.

## Database Architecture
The relational schema consists of **15 normalized tables** covering all core functions:

- Customers, Products, Orders, OrderItems
- Categories and ProductCategories (for many-to-many classification)
- Suppliers and ProductSuppliers (for inventory sourcing)
- Payments, PaymentDetails, CreditCardPayments, GiftCardPayments
- Shipping, Reviews, and Wishlists
Each table has been carefully designed with appropriate foreign key constraints, indexes, and data validation rules to maintain referential integrity and enhance query performance.

## ERD Diagram
<img width="2113" height="1636" alt="ERD" src="https://github.com/user-attachments/assets/8ec270a5-4357-4b30-84ac-c36a3255405c" />


## SQL Implementation Details
The Microsoft SQL Management Server implementation includes **triggers** for automated enforcement of business rules. For example, **stock levels** are **updated automatically** upon order placement or restocking. Other triggers **validate payment** consistency and **restrict incorrect data** entries into sensitive tables like `CreditCardPayments` and `GiftCardPayments`.

Advanced constraints, such as `CHECK`, `UNIQUE`, and `DEFAULT` values, are utilized to ensure data quality and reduce manual error handling.

## SQL Queries Implemented
### Topic 1: Customer
**Query 1:** Retrieve **customer orders** with names, order IDs, product details, quantities, and prices, ordered by customer, order, and product

<img width="618" height="379" alt="image" src="https://github.com/user-attachments/assets/6964025e-edc2-4189-84a4-b1b4b6556f3b" />

**Query 1.1:** Retrieve customer’s ID, full name, the total sales, average order value, and the number of orders *for each customer*

**Nhóm khách hàng nào có lượt mua và mức chi tiêu cao nhất ?**

<img width="543" height="240" alt="image" src="https://github.com/user-attachments/assets/25b44252-17ee-4001-8904-b3ea5ebb3036" />

**Query 1.2:** Retrieve the total number of purchases and the total amount spent for *each shipping city*

**Khu vực quận huyện nào có lượt mua và mức chi tiêu cao nhất ?**

<img width="351" height="162" alt="image" src="https://github.com/user-attachments/assets/e6a42b7f-07e3-435a-9975-d4fad5251d18" />

### Topic 2: Product / Category 
**Query 2:** Retrieve total revenue and quantity sold by *product Category*

**Loại hàng nào được ưa chuộng nhất ?**

<img width="364" height="205" alt="image" src="https://github.com/user-attachments/assets/dc608d54-50f5-4868-bb09-e930aba527ca" />

**Query 2.1:** Retrieve the *top 5 products* by total sales amount, including the total quantity sold and the total revenue generated

**Sản phẩm nào được ưa chuộng nhất ?**

<img width="417" height="120" alt="image" src="https://github.com/user-attachments/assets/ddf7a03c-2bd6-4bde-8413-d893e0e10802" />

**Query 2.2:** Retrieve average customer feedback rating for each product

**Sản phẩm nào được đánh giá thấp nhất, cần cải thiện ?**

<img width="391" height="161" alt="image" src="https://github.com/user-attachments/assets/2539bf20-129c-48d2-9f65-832583466517" />

### Topic 3: Inventory
**Query 3:** Retrieve the product ID, product name, and *current stock quantity (units_in_stock)* for all products

**Kiểm soát mức tồn kho của từng mặt hàng**

<img width="415" height="126" alt="image" src="https://github.com/user-attachments/assets/219f4880-8471-42bb-98da-d53b2904f5e6" />

**Query 3.1:** Calculate the **stock remaining** after fulfilling all orders

<img width="527" height="160" alt="image" src="https://github.com/user-attachments/assets/2ba9b982-980c-4795-99a3-6504101315b3" />

### Topic 4: Payment method 
**Query 4:** Retrieve orders that have both credit card and gift card payments and how much they paid through each payment method

**Khách hàng mua có hỗ trợ thẻ khuyến mãi có quay lại mua không?**

<img width="1029" height="118" alt="image" src="https://github.com/user-attachments/assets/c87b6b55-da4c-4324-9b28-2591d29bf0b6" />

**Query 4.1:** Retrieve group all completed payments by payment method (Credit Card Only, Gift Card Only, or both), calculate the total amount paid for each group

**Số tiền mà Gift CARD hỗ trợ có chiếm phần lớn không?, nếu có thì sẽ cần điều chỉnh**

<img width="367" height="78" alt="image" src="https://github.com/user-attachments/assets/716649a3-b0eb-4cd0-88bb-ec4a227a5e40" />

### Topic 5: Order --> Payment --> Shipping
**Query 5:** Retrieve average time from order to shipping 

<img width="195" height="40" alt="image" src="https://github.com/user-attachments/assets/67623810-eeb3-4b09-a1bc-449e87f9c73d" />

*Số liệu sẽ dễ đánh giá hơn trong bộ dữ liệu lớn thực tế, gồm nhiều tỉnh thành khác nhau*

**Query 5.2** Retrieve average total time by City

<img width="276" height="161" alt="image" src="https://github.com/user-attachments/assets/19ee9953-7537-43a4-8800-27ef7b1e100e" />

*Số liệu sẽ dễ đánh giá hơn trong bộ dữ liệu lớn thực tế, gồm nhiều tỉnh thành khác nhau*

## Future Enhancements
Future expansions include integrating **machine learning** models for inventory forecasting and using **sentiment analysis** on product reviews to better understand customer satisfaction. The system is also designed to scale with **cloud-based analytics** and **BI tools** like Power BI and Tableau for advanced reporting.

## Conclusion
The e-commerce database system provides a comprehensive and scalable solution for managing the core operations of an online retail business. With features that ensure secure transactions, efficient inventory control, and flexible payment handling, the database supports seamless day-to-day operations.

Its modular design and normalization up to 3NF ensure data integrity, performance, and adaptability. By incorporating triggers, advanced SQL features, and analytical capabilities, this project demonstrates a well-rounded database solution that is ready to support future growth and business intelligence needs.

