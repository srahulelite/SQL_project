-- Select top 100 rows to visualize the data
select top 100 * from RealEState Limit


-- Reformat SaleDate Column to Standardize Date
select saledate from RealEState;

Alter table RealEState
Add SaleDateConverted Date;

update RealEState
Set SaleDateConverted = Convert(Date, SaleDate)

select saledate, SaleDateConverted from RealEState;


--Populate Missing data in PropertyAddress
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

