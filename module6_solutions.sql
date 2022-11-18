-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!


	CREATE VIEW vCategories
	WITH SCHEMABINDING
	AS
	SELECT Categoryid, Categoryname
	FROM dbo.Categories
	GO

	CREATE VIEW vProducts
	WITH SCHEMABINDING
	AS
	SELECT ProductId, ProductName, CategoryId, UnitPrice
	FROM dbo.Products
	GO

	CREATE VIEW vEmployees
	WITH SCHEMABINDING
	AS
	SELECT EmployeeId, EmployeeFirstName, EmployeeLastName, ManagerId
	FROM dbo.Employees
	GO

	CREATE VIEW vInventories
	WITH SCHEMABINDING
	AS
	SELECT InventoryId, InventoryDate, EmployeeId, ProductId, Count
	FROM dbo.Inventories
	GO


-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

Deny Select On Employees to Public;
Deny Select On Categories to Public;
Deny Select On Products to Public;
Deny Select On Inventories to Public;

Grant Select On vEmployees to Public;
Grant Select On vCategories to Public;
Grant Select On vProducts to Public;
Grant Select On vInventories to Public;


-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

Create or Alter view vProductsByCategories
 As

	SELECT Top 100000 
	c.categoryname, p.productname, p.unitprice
	FROM vCategories c
	INNER JOIN vProducts p on c.categoryid= p.categoryid
	order by c.categoryname, p.productname;
go

-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00


-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

Create or Alter view vInventoriesByProductsByDates
 As

	SELECT Top 100000
	p.productname, i.inventoryDate, i.Count
	FROM vProducts p
	INNER JOIN vInventories i on p.productid = i.productid
	order by i.inventoryDate, p.productname
go

-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33


-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

Create or Alter view vInventoriesByEmployeesByDates
 As
	select i.inventoryDate, CONCAT(e.employeefirstname , ' ',  e.employeelastname) AS Emaployeename
	FROM vinventories i
	INNER JOIN vEmployees e on i.employeeid = e.employeeid
	group by i.inventoryDate, CONCAT(e.employeefirstname , ' ',  e.employeelastname)
go

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

Create or Alter view vInventoriesByProductsByCategories
 As
	select top 100000
	c.categoryname, p.productname, i.inventorydate, i.Count
	from vproducts p
	inner join vcategories c on p.categoryid = c.categoryid
	inner join vinventories i on p.productid = i.productid
	order by c.categoryname, p.productname, i.inventorydate, i.Count
go

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37


-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

Create or Alter view vInventoriesByProductsByEmployees
 As
	select top 100000
	c.categoryname, p.productname, i.inventorydate, i.Count, concat(e.employeefirstname, ' ', e.employeelastname) as employeename
	from vproducts p
	inner join vcategories c on p.categoryid = c.categoryid
	inner join vinventories i on p.productid = i.productid
	inner join vEmployees e on e.employeeid = i.employeeid
	order by  i.inventorydate, c.categoryname, p.productname,  employeename
go

-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  Côte de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaraná Fantástica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalikööri	      2017-01-01	  57	  Steven Buchanan

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

Create or Alter view vInventoriesForChaiAndChangByEmployees
 As
	select top 100000
	c.categoryname, p.productname, i.inventorydate, i.Count, concat(e.employeefirstname, ' ', e.employeelastname) as employeename
	from vproducts p
	inner join vcategories c on p.categoryid = c.categoryid
	inner join vinventories i on p.productid = i.productid
	inner join vEmployees e on e.employeeid = i.employeeid
	where p.productid in (select productid from vproducts where productname in ('Chai', 'Chang'))
	order by  i.inventorydate, c.categoryname, p.productname,  employeename
go

-- Here are the rows selected from the view:

-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth


-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

Create or Alter view vEmployeesByManager
 As
	select top 100000
	[Manager] = IIF(IsNull(Mgr.EmployeeId, 0) = 0,  Emp.EmployeefirstName + ' ' + Emp.Employeelastname, Mgr.EmployeefirstName + ' ' + Mgr.Employeelastname)
	 ,[Employee Name] =  Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName 
	 From vEmployees as Emp
	 Left Join vEmployees Mgr
	 On Emp.Managerid = Mgr.EmployeeID 
	 Order By 1,2;
go


-- Here are teh rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King


-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

Create or Alter view vInventoriesByProductsByCategoriesByEmployees
 As
	select top 100000
	c.categoryid, c.categoryname, p.productid, p.productname, p.UnitPrice, i.inventoryid, i.inventorydate, i.Count, e.employeeid , e.employeefirstname + ' ' + e.employeelastname as Employee,  m.employeefirstname + ' ' + m.employeelastname as manager
	from vproducts p
	inner join vcategories c on p.categoryid = c.categoryid
	inner join vinventories i on p.productid = i.productid
	inner join vEmployees e on e.employeeid = i.employeeid
	inner join vEmployees m on e.managerid = m.employeeid
	order by  c.categoryname,  p.productname, e.employeeid, i.inventoryid
go

-- Here is an example of some rows selected from the view:
-- CategoryID	  CategoryName	ProductID	ProductName	        UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	          Beverages	    1	        Chai	              18.00	    1	          2017-01-01	  39	  5	          Steven Buchanan
-- 1	          Beverages	    1	        Chai	              18.00	    78	        2017-02-01	  49	  7	          Robert King
-- 1	          Beverages	    1	        Chai	              18.00	    155	        2017-03-01	  59	  9	          Anne Dodsworth
-- 1	          Beverages	    2	        Chang	              19.00	    2	          2017-01-01	  17	  5	          Steven Buchanan
-- 1	          Beverages	    2	        Chang	              19.00	    79	        2017-02-01	  27	  7	          Robert King
-- 1	          Beverages	    2	        Chang	              19.00	    156	        2017-03-01	  37	  9	          Anne Dodsworth
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    24	        2017-01-01	  20	  5	          Steven Buchanan
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    101	        2017-02-01	  30	  7	          Robert King
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    178	        2017-03-01	  40	  9	          Anne Dodsworth
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    34	        2017-01-01	  111	  5	          Steven Buchanan
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    111	        2017-02-01	  121	  7	          Robert King
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    188	        2017-03-01	  131	  9	          Anne Dodsworth

