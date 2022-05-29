select * from NashvilleHousing

--convert date format


select SalesDate , convert(date,saledate) from NashvilleHousing

update NashvilleHousing
set SaleDate=convert(date,saledate)

alter table nashvillehousing
add SalesDate date

update NashvilleHousing
set SalesDate = convert(date,saledate)




--fill the null property address

select a.ParcelID,a.propertyaddress , b.ParcelID ,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing as a
 join NashvilleHousing as b
on a.parcelid=b.parcelid and a.[UniqueID ]<>b.[UniqueID ] 
where a.PropertyAddress is null

update a
set propertyaddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing as a
 join NashvilleHousing as b
on a.parcelid=b.parcelid and a.[UniqueID ]<>b.[UniqueID ] 
where a.PropertyAddress is null



--Address spliting
use [Sql portfolio project]

select PropertyAddress, SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1),
 SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress )+1,LEN(propertyaddress))  from NashvilleHousing

 alter table nashvillehousing
add PropertysplitAddress nvarchar(255)

update NashvilleHousing
set PropertysplitAddress =SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 

alter table nashvillehousing
add PropertysplitCity nvarchar(255)

update NashvilleHousing
set PropertysplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress )+1,LEN(propertyaddress)) 



--split owner address

select  OwnerAddress ,
Parsename(replace(owneraddress,',','.'),3)  ,
Parsename(replace(owneraddress,',','.'),2),
Parsename(replace(owneraddress,',','.'),1)
from NashvilleHousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update NashvilleHousing
set ownersplitaddress = Parsename(replace(owneraddress,',','.'),3)

alter table nashvillehousing
add ownersplitcity nvarchar(255)

update NashvilleHousing
set ownersplitcity = Parsename(replace(owneraddress,',','.'),2)

alter table nashvillehousing
add ownersplitstate nvarchar(255)

update NashvilleHousing
set ownersplitstate = Parsename(replace(owneraddress,',','.'),1)


--remove Y and N 

select SoldAsVacant,
 case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  end
		  from NashvilleHousing

update NashvilleHousing
set SoldAsVacant= case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  end

select distinct(SoldAsVacant), count(soldasvacant) from NashvilleHousing
group by SoldAsVacant

--remove duplicates

with rownumcte as
(
select *, row_number() over(partition by parcelid,salesdate order by uniqueid) row_num from NashvilleHousing)
delete from rownumcte 
where row_num>1


--drop unused columns
select * from NashvilleHousing
alter table NashvilleHousing
drop column propertyaddress , saledate, owneraddress,taxdistrict
