Select *
From Portfolio.dbo.NashvilleHousing

------
Select SaleDate, CONVERT(Date, SaleDate)
From Portfolio.dbo.NashvilleHousing

Update Portfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER Table Portfolio.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update Portfolio.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From Portfolio.dbo.NashvilleHousing



Select *
From Portfolio.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null



Select PropertyAddress
From Portfolio.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN( PropertyAddress)) as Address
From Portfolio.dbo.NashvilleHousing


ALTER Table Portfolio.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table Portfolio.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN( PropertyAddress))

Select *
From Portfolio.dbo.NashvilleHousing

Alter Table Portfolio.dbo.NashvilleHousing
Drop Column SaleDataConverted;

Select OwnerAddress
From Portfolio.dbo.NashvilleHousing

Select PARSENAME(Replace(OwnerAddress,',','.'), 3)
,PARSENAME(Replace(OwnerAddress,',','.'), 2)
,PARSENAME(Replace(OwnerAddress,',','.'), 1)
From Portfolio.dbo.NashvilleHousing

ALTER Table Portfolio.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

ALTER Table Portfolio.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)

ALTER Table Portfolio.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
End	
From Portfolio.dbo.NashvilleHousing

Update Portfolio.dbo.NashvilleHousing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
End	 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num

From Portfolio.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where Row_num > 1
Order by PropertyAddress

Alter Table Portfolio.dbo.NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict

Alter Table Portfolio.dbo.NashvilleHousing
Drop Column SaleDate

Select * 
From Portfolio.dbo.NashvilleHousing