DECLARE @RT INT
exec @RT = ttnha__insert 'MP0006',4,N'Đã bán',N'Phạm Văn Đồng',N'Thủ Đức',N'Ngoại ô',N'TP HCM',NULL,35000000,NULL,'MP',4,'CN0003',6,'2020-10-22','2020-11-22'
IF @RT = 1
	PRINT N'THÊM THẤT BẠI!!!'
ELSE
	PRINT N'THÊM THÀNH CÔNG'
--exec ttnha_delete 'MP0006'