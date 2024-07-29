-- Creazione del database
CREATE DATABASE ToysGroupDB;
USE ToysGroupDB;

-- Creazione delle tabelle
CREATE TABLE Product (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Categoria VARCHAR(100)
);

CREATE TABLE Region (
    ID INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Sales (
    ID INT PRIMARY KEY,
    ProductID INT,
    RegionID INT,
    DataVendita DATE,
    Quantità INT,
    Fatturato DECIMAL(10 , 2 ),
    FOREIGN KEY (ProductID)
        REFERENCES Product (ID),
    FOREIGN KEY (RegionID)
        REFERENCES Region (ID)
);
-- Popolamento delle tabelle 
INSERT INTO Product (ID, Nome, Categoria) VALUES
(1, 'Action Figure Batman', 'Supereroi'),
(2, 'Action Figure Spiderman', 'Supereroi'),
(3, 'Action Figure Iron Man', 'Supereroi'),
(4, 'Peluche Orso', 'Animali di Peluche'),
(5, 'Peluche Coniglio', 'Animali di Peluche'),
(6, 'Peluche Gatto', 'Animali di Peluche'),
(7, 'Puzzle 3D Torre Eiffel', 'Puzzle 3D'),
(8, 'Puzzle 3D Statua della Libertà', 'Puzzle 3D'),
(9, 'Puzzle 3D Colosseo', 'Puzzle 3D'),
(10, 'Action Figure Superman', 'Supereroi'),
(11, 'Action Figure Hulk', 'Supereroi'),
(12, 'Peluche Cane', 'Animali di Peluche'),
(13, 'Peluche Tigre', 'Animali di Peluche'),
(14, 'Puzzle 3D Big Ben', 'Puzzle 3D'),
(15, 'Puzzle 3D Taj Mahal', 'Puzzle 3D'); -- Prodotto invenduto

INSERT INTO Region (ID, Nome) VALUES
(1, 'Europa'),
(2, 'Asia'),
(3, 'America'),
(4, 'Africa'),
(5, 'Oceania');

INSERT INTO Sales (ID, ProductID, RegionID, DataVendita, Quantità, Fatturato) VALUES
(1, 1, 1, '2023-01-15', 100, 5000.00),
(2, 2, 1, '2023-01-16', 200, 10000.00),
(3, 3, 2, '2023-02-10', 150, 7500.00),
(4, 4, 3, '2023-03-05', 300, 15000.00),
(5, 5, 4, '2023-04-10', 50, 2500.00),
(6, 6, 5, '2023-05-15', 60, 3000.00),
(7, 7, 1, '2023-06-20', 70, 3500.00),
(8, 8, 2, '2023-07-25', 80, 4000.00),
(9, 9, 3, '2023-08-30', 90, 4500.00),
(10, 10, 4, '2023-09-05', 100, 5000.00),
(11, 11, 5, '2023-10-10', 110, 5500.00),
(12, 12, 1, '2023-11-15', 120, 6000.00),
(13, 13, 2, '2023-12-20', 130, 6500.00),
(14, 14, 3, '2024-01-25', 140, 7000.00);
-- Verifica unicità delle chiavi primarie
SELECT ID FROM Product GROUP BY ID HAVING COUNT(*) > 1;
SELECT ID FROM Region GROUP BY ID HAVING COUNT(*) > 1;
SELECT 
    ID
FROM
    Sales
GROUP BY ID
HAVING COUNT(*) > 1;

-- Elenco dei soli prodotti venduti e il fatturato totale per anno
SELECT 
    p.Nome,
    YEAR(s.DataVendita) AS Anno,
    SUM(s.Fatturato) AS FatturatoTotale
FROM
    Product p
        JOIN
    Sales s ON p.ID = s.ProductID
GROUP BY p.Nome , YEAR(s.DataVendita);

-- Fatturato totale per stato per anno ordinato per data e fatturato decrescente
SELECT 
    r.Nome,
    YEAR(s.DataVendita) AS Anno,
    SUM(s.Fatturato) AS FatturatoTotale
FROM
    Region r
        JOIN
    Sales s ON r.ID = s.RegionID
GROUP BY r.Nome , YEAR(s.DataVendita)
ORDER BY YEAR(s.DataVendita) DESC , SUM(s.Fatturato) DESC;

-- Categoria di articoli maggiormente richiesta dal mercato
SELECT 
    p.Categoria, SUM(s.Quantità) AS QuantitàTotale
FROM
    Product p
        JOIN
    Sales s ON p.ID = s.ProductID
GROUP BY p.Categoria
ORDER BY SUM(s.Quantità) DESC
LIMIT 1;

-- Prodotti che non appaiono nella tabella Sales
SELECT 
    p.Nome
FROM
    Product p
        LEFT JOIN
    Sales s ON p.ID = s.ProductID
WHERE
    s.ID IS NULL;

-- Prodotti con quantità venduta pari a zero
SELECT 
    p.Nome
FROM
    Product p
        LEFT JOIN
    Sales s ON p.ID = s.ProductID
GROUP BY p.Nome
HAVING SUM(s.Quantità) = 0;

-- Elenco dei prodotti con la rispettiva ultima data di vendita
SELECT 
    p.Nome, MAX(s.DataVendita) AS UltimaDataVendita
FROM
    Product p
        JOIN
    Sales s ON p.ID = s.ProductID
GROUP BY p.Nome;
