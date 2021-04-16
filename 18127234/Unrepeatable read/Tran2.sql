--exec ttnha__insert 'MP0006',5,N'Còn trống',N'Đường số 5',N'Bình Chánh',N'Ngoại ô',N'TP HCM',50000000,NULL,NULL,'MP',4,'CN0001',7,'2020-10-23','2020-11-23'
DECLARE @RT INT
exec @RT = ttnha_delete 'MP0006'
IF @RT = 1
	PRINT N'XÓA THẤT BẠI'
ELSE
	PRINT N'XÓA THÀNH CÔNG'