---Cleaning dat in SQL Queries

Select* from [Portofolio Project].dbo.NashvilleHousing

-- Standardize data format

Select saledate from [Portofolio Project].dbo.NashvilleHousing

-- convert from dattime to date_
Select SaleDate,CONVERT(Date,SaleDate) from [Portofolio Project].dbo.NashvilleHousing

Update [Portofolio Project].dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE [Portofolio Project].dbo.NashvilleHousing
Add SaleDateConverted Date;
Update [Portofolio Project].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted from [Portofolio Project].dbo.NashvilleHousing

-- Puppulate rpoperty address


Select *
from [Portofolio Project].dbo.NashvilleHousing
Where PropertyAddress is null


Select *
from [Portofolio Project].dbo.NashvilleHousing
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Portofolio Project].dbo.NashvilleHousing a
Join [Portofolio Project].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [Portofolio Project].dbo.NashvilleHousing a
Join [Portofolio Project].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking our Address into individual columns
Select *
from [Portofolio Project].dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address

from [Portofolio Project].dbo.NashvilleHousing

ALTER TABLE [Portofolio Project].dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [Portofolio Project].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portofolio Project].dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portofolio Project].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
from [Portofolio Project].dbo.NashvilleHousing

Select OwnerAddress
from [Portofolio Project].dbo.NashvilleHousing

Select
PARSENAME (replace(OwnerAddress,',','.'),3)
,PARSENAME (replace(OwnerAddress,',','.'),2)
,PARSENAME (replace(OwnerAddress,',','.'),1)
from [Portofolio Project].dbo.NashvilleHousing

ALTER TABLE [Portofolio Project].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Portofolio Project].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portofolio Project].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update[Portofolio Project].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE[Portofolio Project].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Portofolio Project].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (soldasvacant),COUNT(soldasvacant)
From [Portofolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select soldasvacant
, case when SoldAsVacant= 'Y' Then 'Yes'
	When SoldAsVacant= 'N' Then 'No'
	else SoldAsVacant
	END
From [Portofolio Project].dbo.NashvilleHousing


Update [Portofolio Project].dbo.NashvilleHousing
set SoldAsVacant =case when SoldAsVacant= 'Y' Then 'Yes'
	When SoldAsVacant= 'N' Then 'No'
	else SoldAsVacant
	END

Select Distinct (soldasvacant),COUNT(soldasvacant)
From [Portofolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

-- Remove Duplicates
WITH RowNumCTE as (
Select *, 
	Row_number() Over(
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
					UniqueID
					) row_num
From [Portofolio Project].dbo.NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
Where row_num >1

WITH RowNumCTE as (
Select *, 
	Row_number() Over(
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
					UniqueID
					) row_num
From [Portofolio Project].dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num >1
order by Propertyaddress

Alter Table [Portofolio Project].dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [Portofolio Project].dbo.NashvilleHousing
Drop Column SaleDate

Select *
From [Portofolio Project].dbo.NashvilleHousing