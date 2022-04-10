SELECT * 
FROM [Nashville New Table 1]

--Populate Property Address Data
SELECT *
FROM [Nashville New Table 1]
--WHERE PropertyAddress is NULL
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville New Table 1] a 
JOIN [Nashville New Table 1] b
on a.ParcelID = b.ParcelID
and a. UniqueID <> b. UniqueID
WHERE a.PropertyAddress is NULL

Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville New Table 1] a 
JOIN [Nashville New Table 1] b
on a.ParcelID = b.ParcelID
and a. UniqueID <> b. UniqueID
WHERE a.PropertyAddress is NULL


--Breaking Out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [Nashville New Table 1]
--WHERE PropertyAddress is NULL
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) as Address
FROM [Nashville New Table 1]

ALTER TABLE [Nashville New Table 1]
ADD PropertySplitAddress NVARCHAR(255);

UPDATE [Nashville New Table 1]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [Nashville New Table 1]
ADD PropertySplitCity NVARCHAR (255);

UPDATE [Nashville New Table 1]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))

SELECT *
FROM [Nashville New Table 1]

SELECT OwnerAddress
FROM [Nashville New Table 1]

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [Nashville New Table 1]

ALTER TABLE [Nashville New Table 1]
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE [Nashville New Table 1]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [Nashville New Table 1]
ADD OwnerSplitCity NVARCHAR(255);

UPDATE [Nashville New Table 1]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [Nashville New Table 1]
ADD OwnerSplitState NVARCHAR(255);

UPDATE [Nashville New Table 1]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
FROM [Nashville New Table 1]

--Change Y and N to Yes and No in '"Sold As Vacant" field

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM [Nashville New Table 1]
GROUP BY(SoldAsVacant)
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END

FROM [Nashville New Table 1]

UPDATE [Nashville New Table 1]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END


 --Remove Duplicates
WITH RowNumCTE AS(
 SELECT *,
 ROW_NUMBER()OVER(
     PARTITION BY ParcelID,
     PropertyAddress,
     SalePrice,
     SaleDate,
     LegalReference
     ORDER BY 
     UniqueID
  ) row_num

FROM [Nashville New Table 1]
 --ORDER BY ParcelID
)

Select *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

--Delete Unused Columns
SELECT *
FROM [Nashville New Table 1]

ALTER TABLE [Nashville New Table 1]
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict