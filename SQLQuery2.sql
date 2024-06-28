
-- Standardizing the date format

select SaleDate,CONVERT(date,SaleDate) from Sqlproject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate= CONVERT(date,SaleDate)

select* from Sqlproject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted= CONVERT(date,SaleDate)

-- Populate property address data

select * from Sqlproject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)	 
from Sqlproject.dbo.NashvilleHousing a
JOIN Sqlproject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Sqlproject.dbo.NashvilleHousing a
JOIN Sqlproject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking the address into individual columns (Address,city,state)
select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from Sqlproject.dbo.NashvilleHousing

-- Adding column for splitting Address

Alter table NashvilleHousing
Add PropertySplitAddress Varchar(255);

Update NashvilleHousing
Set PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

-- Adding column for splitting City
Alter table NashvilleHousing
Add PropertySplitCity Varchar(255);

Update NashvilleHousing
Set PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))



select parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from Sqlproject.dbo.NashvilleHousing


ALTER TABLE Sqlproject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Sqlproject.dbo.NashvilleHousing
Set OwnerSplitAddress= parsename(replace(OwnerAddress,',','.'),3)

-- Adding column for splitting City
Alter table Sqlproject.dbo.NashvilleHousing
Add OwnerSplitCity Varchar(255);

Update Sqlproject.dbo.NashvilleHousing
Set OwnerSplitCity= parsename(replace(OwnerAddress,',','.'),2)

Alter table Sqlproject.dbo.NashvilleHousing
Add OwnerSplitState Varchar(255);

Update Sqlproject.dbo.NashvilleHousing
Set OwnerSplitState= parsename(replace(OwnerAddress,',','.'),1)





-- Change 'Y' and 'N' to Yes and NO in 'SoldAsVacant' column

select SoldAsVacant,
Case 
when SoldAsVacant ='N' then 'No'
when SoldAsVacant ='Y' then 'Yes'
ELSE SoldAsVacant
end
from Sqlproject.dbo.NashvilleHousing;


UPDATE Sqlproject.dbo.NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant ='N' then 'No'
						when SoldAsVacant ='Y' then 'Yes'
						ELSE SoldAsVacant
						END


SELECT DISTINCT(SoldAsVacant),Count(SoldAsVacant)
from Sqlproject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;


-- Removing the Duplicates

-- This below code is to check the duplicates in the dataset and below to this one we have another code to delete the duplicates
WITH RowNumCTE As (

Select *, ROW_NUMBER() Over(partition by ParcelID,
									  PropertyAddress,
									  SalePrice,
									  SaleDate,
									  LegalReference
									  ORDER BY
										UniqueID
										) row_num
										
								

from Sqlproject.dbo.NashvilleHousing
)
Select * from RowNumCTE
where row_num>1
order by PropertyAddress


--to delete
WITH RowNumCTE As (

Select *, ROW_NUMBER() Over(partition by ParcelID,
									  PropertyAddress,
									  SalePrice,
									  SaleDate,
									  LegalReference
									  ORDER BY
										UniqueID
										) row_num
										
								

from Sqlproject.dbo.NashvilleHousing
)
DELETE from RowNumCTE
where row_num>1


-- Delete unused columns from the dataset
Select * from Sqlproject.dbo.NashvilleHousing;

ALTER TABLE Sqlproject.dbo.NashvilleHousing
Drop Column SaleDate