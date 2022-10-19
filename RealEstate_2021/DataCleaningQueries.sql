-- Select top 100 rows to visualize the data
select top 100 * from RealEState Limit


-- Reformat SaleDate Column to Standardize Date
select saledate from RealEState;

Alter table RealEState
Add SaleDateConverted Date;

update RealEState
Set SaleDateConverted = Convert(Date, SaleDate)

select saledate, SaleDateConverted from RealEState;


-- Populate Missing data in PropertyAddress
select a.UniqueID, b.[UniqueID ], a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress 
from RealEState a JOIN RealEState b on
a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from RealEState a
join RealEState b on
a.ParcelID = b.ParcelID and
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking Property Address into different Columns
select PropertyAddress from RealEState

select PropertyAddress, 
Substring(PropertyAddress, 1, (CHARINDEX(',', PropertyAddress)-1))
as address1,
Substring(PropertyAddress, (CHARINDEX(',',PropertyAddress)+2), (CHARINDEX(',', PropertyAddress)-1))
as  address2
from RealEState


select Substring(PropertyAddress, (CHARINDEX(',',PropertyAddress)+2), (CHARINDEX(',', PropertyAddress)-1))
as address from RealEState

Alter table RealEstate
Add PropertySplitAddress nvarchar(255)

Alter table RealEstate
Add PropertySplitCity nvarchar(255)

update RealEState
set PropertySplitAddress = Substring(PropertyAddress, 1, (CHARINDEX(',', PropertyAddress)-1))

update RealEState
set PropertySplitCity = Substring(PropertyAddress, (CHARINDEX(',',PropertyAddress)+2), (CHARINDEX(',', PropertyAddress)-1))

select * from RealEState

-- Breaking down OwnerAddress in Columns
select 
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from RealEState

Alter table RealEstate
Add OwnerSplitAddress1 nvarchar(255)

Alter table RealEstate
Add OwnerSplitAddress2 nvarchar(255)

Alter table RealEstate
Add OwnerSplitAddress3 nvarchar(255)

update RealEState
set OwnerSplitAddress1 = PARSENAME(replace(OwnerAddress, ',', '.'), 3)


update RealEState
set OwnerSplitAddress2 = PARSENAME(replace(OwnerAddress, ',', '.'), 2)


update RealEState
set OwnerSplitAddress3 = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

select * from RealEState

-- Changing y to yes and n to no for consistency in SoldAsVacant column 
select distinct(SoldAsVacant), count(SoldAsVacant) from RealEState
group by SoldAsVacant
order by 2

select SoldAsVacant,
	Case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
	End
from RealEState

Update RealEState
set SoldAsVacant = 
Case	
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
End

--Remove Duplicates
with RowNumCTE as(
select *,
ROW_NUMBER() over (partition by 
parcelID, 
propertyAddress, 
SalePrice, 
SaleDate,
legalReference
order by
	uniqueID
) row_num
from RealEState
--order by ParcelID
)
--delete from RowNumCTE
--where row_num > 1
select * from RowNumCTE where row_num > 1

-- Delete Unused columns

Alter table RealEstate
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

select * from RealEState

