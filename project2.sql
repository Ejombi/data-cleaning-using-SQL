 ---general overview of data
select*
from [porfolio project 2]..NashvilleHousing

---standardizing date format of saledate

select SaleDateConverted,convert(date,saledate)
from [porfolio project 2]..NashvilleHousing

update NashvilleHousing
set SaleDate=convert(date,saledate)

alter table NashvilleHousing
add SaledateConverted Date;

update Nashvillehousing
set SaleDateConverted=convert(date,saledate)

---populate property address data

select *
from [porfolio project 2]..NashvilleHousing
---where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [porfolio project 2]..NashvilleHousing a
join [porfolio project 2]..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [porfolio project 2]..NashvilleHousing a
join [porfolio project 2]..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--BREAKING OUT ADRESS INTO INDIVIDUAL COLUMNS (Address,City,State)
select PropertyAddress
from [porfolio project 2]..NashvilleHousing

select 
SUBSTRING( PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))as Address
from [porfolio project 2]..NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress=SUBSTRING( PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

update NashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [porfolio project 2]..NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);
alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);
alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)
update NashvilleHousing
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
update NashvilleHousing
set OwnerSplitstate=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

----------------------------------------------------------------------------------------------
--Change Y and N to Yes and NO in "Sold as Vacant"field

select Distinct(SoldAsVacant),count(SoldAsVacant)
from [porfolio project 2]..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant ='Y'then 'Yes'
     when SoldAsVacant ='N'then 'No'
	 else SoldAsVacant
	 end
     from [porfolio project 2]..NashvilleHousing

	 update NashvilleHousing
	 set SoldAsVacant=case when SoldAsVacant ='Y'then 'Yes'
     when SoldAsVacant ='N'then 'No'
	 else SoldAsVacant 
	 end

	 --------------------------------------------------------------------------------------------------------
	 --REMOVE DUPLICATES
	 WITH RowNumberCTE AS(
	 select*,
	 Row_number () OVER (
	 partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				 Saledate,
				 LegalReference
				 order by UniqueID
				 ) row_num
	  from [porfolio project 2]..NashvilleHousing
	 )

	 SELECT*
	 from RowNumberCTE
	 where row_num>1
	order by PropertyAddress

	------------------------------------------------------------------------------------------------------------------------
---DELETE UNUSED COLOUMS

select*
 from [porfolio project 2]..NashvilleHousing

 alter table [porfolio project 2]..NashvilleHousing
 drop column OwnerAddress,TaxDistrict,PropertyAddress

 alter table [porfolio project 2]..NashvilleHousing
 drop column SaleDate 