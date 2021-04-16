begin tran
exec TimKiemKhuVuc N'Ngoại ô'
WAITFOR DELAY '0:0:15'
--Test 
select *
from NHA
where nha_kvuc = N'Ngoại ô'
commit tran