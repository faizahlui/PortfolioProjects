--Cleansed DimDate Table & Also filter for 2019 year only 
SELECT 
  [FullDateAlternateKey] AS Date --,[DayNumberOfWeek]
  ,   [EnglishDayNameOfWeek] AS Day --,[SpanishDayNameOfWeek]
  --,[FrenchDayNameOfWeek]
  --,[DayNumberOfMonth]
  --,[DayNumberOfYear]
  ,[WeekNumberOfYear] AS WeekNr, 
  [EnglishMonthName] AS Month, 
  LEFT([EnglishMonthName], 3) AS MonthShort --,[SpanishMonthName]
  --,[FrenchMonthName]
  ,[MonthNumberOfYear] AS MonthNr, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
  --,[CalendarSemester]
  --,[FiscalQuarter]
  --,[FiscalYear]
  --,[FiscalSemester]
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate] 
WHERE 
  CalendarYear >= 2019