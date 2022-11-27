/*The sales manager was intetrested in looking at the sales per product. Below is the cleansed DIM products table */

SELECT p.[ProductKey]
      ,p.[ProductAlternateKey] AS ProductItemCode 
--      ,[ProductSubcategoryKey]
--      ,[WeightUnitMeasureCode]
--      ,[SizeUnitMeasureCode]
        ,p.[EnglishProductName] AS ProductName
		,pc.EnglishProductCategoryName AS ProductCategory -- join from the product category table 
		,ps.EnglishProductSubcategoryName AS ProductSubCategory -- join from the product sub category table
--      ,[SpanishProductName]
--      ,[FrenchProductName]
--      ,[StandardCost]
--      ,[FinishedGoodsFlag]
      ,p.[Color] AS ProductColor 
      --,p.[SafetyStockLevel]
      --,p.[ReorderPoint]
      --,[ListPrice]
      ,p.[Size]
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,p.[ProductLine] AS ProductLine
--      ,[DealerPrice]
--      ,[Class]
--      ,[Style]
      ,p.[ModelName] AS ProductModelName
--      ,[LargePhoto]
      ,p.[EnglishDescription] AS ProductDescription 
--      ,[FrenchDescription]
--      ,[ChineseDescription]
--      ,[ArabicDescription]
--      ,[HebrewDescription]
      --,[ThaiDescription]
      --,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
--      ,[StartDate]
--      ,[EndDate]
      ,ISNULL (p.Status, 'Outdated') AS ProductStatus -- replace null value 
  FROM [AdventureWorksDW2019].[dbo].[DimProduct] AS p
  LEFT JOIN AdventureWorksDW2019.dbo.DimProductSubCategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey -- left join 
  LEFT JOIN AdventureWorksDW2019.dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey -- left join 
  ORDER BY p.ProductKey ASC