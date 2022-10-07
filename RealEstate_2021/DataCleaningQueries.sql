-- Select top 100 rows to visualize the data
select top 100 * from RealEState Limit

-- Reformat SaleDate Column to Standardize Date
select saledate from RealEState;

Alter table RealEState
Add SaleDateConverted Date;

update RealEState
Set SaleDateConverted = Convert(Date, SaleDate)

select saledate, SaleDateConverted from RealEState;

