CREATE TABLE roles (
    role_id INTEGER PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);
CREATE TABLE user_roles (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    role_id INTEGER NOT NULL REFERENCES roles(role_id),
    PRIMARY KEY (user_id, role_id)
);
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE medicines (
    medicine_id INTEGER PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES categories(category_id),
    name VARCHAR(150) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    expiry_date DATE NOT NULL
);
CREATE TABLE notifications (
    notification_id INTEGER PRIMARY KEY,
    medicine_id INTEGER NOT NULL REFERENCES medicines(medicine_id),
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);
INSERT INTO roles VALUES
(1, 'Әкімші'), (2, 'Дәріхана қызметкері'), (3, 'Қойма қызметкері');
INSERT INTO users VALUES
(1, 'admin', 'demo_hash_1'), (2, 'pharmacist', 'demo_hash_2'), (3, 'warehouse', 'demo_hash_3');
INSERT INTO user_roles VALUES (1, 1), (2, 2), (3, 3), (2, 3);
INSERT INTO categories VALUES
(1, 'Ауырсынуды басатын дәрілер'), (2, 'Антибиотиктер'), (3, 'Витаминдер');
INSERT INTO medicines VALUES
(1, 1, 'Парацетамол', 50, '2027-05-20'),
(2, 1, 'Ибупрофен', 30, '2026-12-10'),
(3, 2, 'Амоксициллин', 25, '2026-10-15'),
(4, 3, 'Витамин C', 80, '2027-08-25'),
(5, 2, 'Азитромицин', 15, '2026-11-10');
INSERT INTO notifications VALUES
(1, 3, 'Жарамдылық мерзімі өткен', '2026-11-25 09:00:00'),
(2, 5, 'Жарамдылық мерзімі өткен', '2026-11-25 09:00:00'),
(3, 2, 'Жарамдылық мерзімі аяқталуға жақын', '2026-11-25 09:00:00');

-- JOIN: үш кестені біріктіру
SELECT m.name AS medicine, c.name AS category, m.expiry_date, n.message
FROM medicines m
JOIN categories c ON m.category_id = c.category_id
JOIN notifications n ON m.medicine_id = n.medicine_id
ORDER BY m.expiry_date;

-- GROUP BY: санат бойынша дәрілер саны
SELECT c.name AS category, COUNT(m.medicine_id) AS medicine_count,
       SUM(m.quantity) AS total_quantity
FROM categories c
JOIN medicines m ON c.category_id = m.category_id
GROUP BY c.category_id, c.name
ORDER BY c.category_id;
