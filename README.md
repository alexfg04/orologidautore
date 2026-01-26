# ⌚ Orologi D'Autore - E-Commerce Project

E-Commerce platform dedicated to luxury watches, developed as a final project for the **Web Technologies and Software** course at the **University of Salerno** (A.Y. 2024/2025).

---

### 🚀 Overview
Orologi D'Autore is a full-stack web application that allows users to browse a catalog of high-end watches, manage a shopping cart, and securely complete purchases. It also features a robust Administrative Dashboard for inventory and order management.

### 🛠️ Tech Stack

**Core & Backend**
![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=flat-square&logo=openjdk&logoColor=white) ![Servlet](https://img.shields.io/badge/Servlet-orange?style=flat-square) ![JSP](https://img.shields.io/badge/JSP-blue?style=flat-square) ![Maven](https://img.shields.io/badge/Apache%20Maven-C71A36?style=flat-square&logo=Apache%20Maven&logoColor=white)

**Frontend & UX**
![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=flat-square&logo=html5&logoColor=white) ![CSS3](https://img.shields.io/badge/css3-%231572B6.svg?style=flat-square&logo=css3&logoColor=white) ![JavaScript](https://img.shields.io/badge/javascript-%23F7DF1E.svg?style=flat-square&logo=javascript&logoColor=black) ![AJAX](https://img.shields.io/badge/AJAX-005A9C?style=flat-square&logo=jquery&logoColor=white)

**Database & Integration**
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=flat-square&logo=mysql&logoColor=white) ![PayPal](https://img.shields.io/badge/PayPal-003087?style=flat-square&logo=paypal&logoColor=white)

---

### ✨ Key Features

- **User Authentication**: Secure signup and login with AJAX error handling (e.g., checking for existing users).
- **Catalog & Favorites**: Advanced filtering by gender and price, and a personalized wishlist system.
- **Shopping Cart**: Real-time updates and management of selected items.
- **Admin Dashboard**: 
  - Full CRUD for products (add, modify, remove).
  - Advanced order tracking by user and timeline.
  - Sales data visualization through dynamic charts.
- **Payment Integration**: Support for PayPal transactions.

---

### 📂 Project Structure Highlights
- `/src/main/java`: MVC architecture implementation (Dao/Bean pattern).
- `/db_schema`: SQL scripts for database initialization.
- `/src/main/webapp`: JSP views and static assets (CSS, JS, Images).

---

### 🛠️ Installation & Setup
1. Clone the repository.
2. Import `schema.sql` into your MySQL instance.
3. Configure the database connection in `DataSourceConnectionPool.java`.
4. Build the project using Maven: `mvn clean install`.
5. Deploy the WAR file to an Apache Tomcat server.
