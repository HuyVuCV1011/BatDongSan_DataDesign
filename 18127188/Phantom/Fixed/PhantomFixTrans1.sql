
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
exec ttkh_view N'Nguyen Van D'
waitfor delay '00:00:20'
commit transaction