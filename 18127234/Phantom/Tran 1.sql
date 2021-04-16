begin tran
exec TimKiemGiaBanTangDan 30000000

--Test

select *
from NHA
where nha_giab> 30000000
commit tran
