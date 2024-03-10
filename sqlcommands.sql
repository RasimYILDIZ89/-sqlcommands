--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) 
 --değerlerini almak için sorgu yazın.
 
SELECT product_name, quantity_per_unit
FROM products;

/*2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın.
Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.*/

SELECT product_id,product_name
FROM products
WHERE discontinued = 0;

/*3. Durdurulmayan (`Discontinued`) Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) 
değerleriyle almak için bir sorgu yazın.*/

SELECT product_id,product_name,discontinued
FROM products
WHERE discontinued = 0;  -- 1 durumunda ürünün durdurulmuş olduğunu varsayıyorum.

/*4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) 
almak için bir sorgu yazın.*/

SELECT product_id,product_name,unit_price
FROM products WHERE unit_price<20;

/*5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini 
(`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.*/

SELECT product_id,product_name,unit_price
FROM products WHERE 15<unit_price AND unit_price<20;

/*6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) 
stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.*/

SELECT product_name,units_on_order,units_in_stock
FROM products WHERE units_on_order>units_in_stock;

--7. İsmi `a` ile başlayan ürünleri listeleyeniz.

SELECT product_id,product_name
FROM products 
WHERE LOWER(product_name) LIKE 'a%';

SELECT product_id,product_name
FROM products
WHERE LOWER(SUBSTRING(product_name FROM 1 FOR 1)) = 'a';

--8. İsmi `i` ile biten ürünleri listeleyeniz.
SELECT product_id,product_name
FROM products 
WHERE LOWER(product_name) LIKE '%i';

SELECT product_id,product_name
FROM products
WHERE LOWER(SUBSTRING(product_name FROM LENGTH(product_name) FOR 1)) = 'i';

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak 
--(ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.

SELECT product_id,product_name,unit_price,unit_price * 0.18 AS KDV, unit_price + (unit_price*0.18) AS unit_Price_With_KDV
FROM products;

--10. Fiyatı 30 dan büyük kaç ürün var?

SELECT COUNT(*) AS product_count
FROM products
WHERE unit_price>30;

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele

SELECT product_name,LOWER(product_name) AS lower_case_product_name,unit_price
FROM products
ORDER BY unit_price DESC;

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır

SELECT first_name,last_name,CONCAT(first_name,' ',last_name)AS full_name
FROM employees;

--13. Region alanı NULL olan kaç tedarikçim var?

SELECT COUNT(*) AS null_region_supplier_count
FROM suppliers
WHERE region IS NULL;

--14. a.Null olmayanlar?

SELECT region
FROM suppliers
WHERE region IS NOT NULL;

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.

SELECT product_name,CONCAT ('TR',UPPER(product_name)) AS upper_case_product_name
FROM products;

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle

SELECT 
  CASE 
    WHEN unit_price < 20 THEN CONCAT('TR ', UPPER(product_name))
    ELSE UPPER(product_name)
  END AS upper_case_product_name
FROM products;

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name,unit_price
FROM products
ORDER BY unit_price DESC; -- sonuna LIMIT 1; yaparsak en yüksek fiyatlıyı alır. 

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name,unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

SELECT product_name,unit_price
FROM products
GROUP BY  product_name,unit_price
HAVING unit_price>(SELECT AVG(unit_price) FROM products);

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.

SELECT SUM(units_in_stock*unit_price) AS total_revenue
FROM products
WHERE units_in_stock>0;

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.

SELECT
  SUM(CASE WHEN discontinued = 0 THEN 1 ELSE 0 END) AS active_products,
  SUM(CASE WHEN discontinued = 1 THEN 1 ELSE 0 END) AS discontinued_products
FROM products;

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.

SELECT 
products.product_id,
products.product_name,
products.unit_price,
categories.category_name
FROM products
JOIN 
categories ON products.category_id = categories.category_id;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.

SELECT 
categories.category_name,
AVG(products.unit_price) AS average_price
FROM 
products
JOIN 
categories ON products.category_id = categories.category_id
GROUP BY 
categories.category_name;

--24. En pahalı ürünümün adı, fiyatı ve kategorisinin adı nedir?

SELECT 
categories.category_name,
products.product_name,
products.unit_price
FROM products
JOIN
categories ON products.category_id = categories.category_id
ORDER BY
products.unit_price DESC
LIMIT 1;

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı

SELECT 
products.product_name,
categories.category_name,
suppliers.company_name,
COUNT(*) AS sales_count
FROM 
orders
JOIN 
order_details ON orders.order_id = order_details.order_id
JOIN 
products ON order_details.product_id = products.product_id
JOIN 
categories ON products.category_id = categories.category_id
JOIN 
suppliers ON products.supplier_id = suppliers.supplier_id
GROUP BY 
products.product_name, categories.category_name, suppliers.company_name
ORDER BY 
sales_count DESC
LIMIT 1;
