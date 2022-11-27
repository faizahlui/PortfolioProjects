/****** Extract customer details and also doing join for customer and geography table to obtain the customer location details  ******/
SELECT c.[CustomerKey] AS CustomerKey
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,c.[FirstName] AS FirstName
      --,[MiddleName]
      ,c.[LastName] AS LastName
	  ,c.[FirstName] + ' ' + c.[LastName] AS [FullName] -- Concatenating customer first name and last name to make the full name 
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      ,CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,c.[DateFirstPurchase] AS DateFirstPurchase
      --,[CommuteDistance]
	  ,g.[City] AS [Customer City] 
	  ,g.[EnglishCountryRegionName] AS [Customer Region]
  FROM AdventureWorksDW2019.dbo.DimCustomer AS c -- LEFT JOIN with the geographical data to pull customer city and region 
  LEFT JOIN AdventureWorksDW2019.dbo.DimGeography AS g
  ON g.[GeographyKey] = c.[GeographyKey]
  ORDER BY   CustomerKey  -- Ordered list by CustomerKey