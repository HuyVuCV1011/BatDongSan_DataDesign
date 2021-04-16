SET DEADLOCK_PRIORITY NORMAL
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
exec ttnha_view 'BT0006'
waitfor delay '00:00:15'
exec ttnha__update  'BT0006',6,N'Còn trống',N'Đường số 1',N'Quận 8**',N'Trung tâm',N'TP HCM',36000000.0,NULL,NULL,'BT',5,'CN0002',8,'2020-10-21','2020-11-21'
				  
commit transaction