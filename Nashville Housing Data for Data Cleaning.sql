/*
CLEANING DATA IN SQL QUERIES 

*/ 

SELECT * 
FROM PortfolioProjectAlex..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--STANDARDIZING DATE FORMAT

SELECT SaleDate, CONVERT (DATE, SaleDate) AS SaleDateConverted
FROM PortfolioProjectAlex..NashvilleHousing


--My system doesnt directly update below coding
UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted  DATE

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

--Checking to see if it's working
SELECT *
FROM PortfolioProjectAlex..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

SELECT *
FROM PortfolioProjectAlex..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID 


SELECT [UniqueID ],ParcelID,PropertyAddress,OwnerAddress
FROM PortfolioProjectAlex..NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID 


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM PortfolioProjectAlex..NashvilleHousing a
JOIN PortfolioProjectAlex..NashvilleHousing b
	ON a.[UniqueID ]<>b.[UniqueID ]
	AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectAlex..NashvilleHousing a
JOIN PortfolioProjectAlex..NashvilleHousing b
	ON a.[UniqueID ]<>b.[UniqueID ]
	AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress IS NULL




--------------------------------------------------------------------------------------------------------------------------

--Breaking Out Address in Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProjectAlex..NashvilleHousing


SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS PropertySplitAddress
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)-1 , LEN(PropertyAddress)) AS PropertySplitCity
FROM PortfolioProjectAlex..NashvilleHousing


ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing 
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)-1 , LEN(PropertyAddress))

SELECT PropertySplitAddress,PropertySplitCity 			-- Check if data inserted, 
FROM PortfolioProjectAlex..NashvilleHousing

-- Split Owner Address

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS OwnerAddressSplit
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS OwnerCitySplit
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS OwnerStateSplit
FROM PortfolioProjectAlex..NashvilleHousing 


ALTER TABLE NashvilleHousing
ADD   OwnerAddressSplit nvarchar(255),
OwnerCitySplit nvarchar(255),
OwnerStateSplit nvarchar(255)

UPDATE NashvilleHousing
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,OwnerCitySplit = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 
,OwnerStateSplit = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

SELECT OwnerAddressSplit,OwnerCitySplit,OwnerStateSplit -- Checking if data updated
FROM NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

--Update 'Y' and 'N' as 'Yes' and 'No'


SELECT DISTINCT(SoldAsVacant)
,COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant)


SELECT CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
 WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS 
(
SELECT *, 
ROW_NUMBER () OVER (PARTITION BY 
					ParcelID, 
					PropertyAddress,
					SalePrice, 
					SaleDate,
					LegalReference
					ORDER BY 
						UniqueID
						) row_num
FROM PortfolioProjectAlex..NashvilleHousing 
)

SELECT *
FROM RowNumCTE
WHERE row_num >1

DELETE --Use to delete the duplicate rows
FROM RowNumCTE
WHERE row_num >1

--------------------------------------------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

SELECT *
FROM  PortfolioProjectAlex..NashvilleHousing 

ALTER TABLE PortfolioProjectAlex..NashvilleHousing  
DROP PropertyAddress, SaleDate,OwnerAdress, TaxDistrict 

