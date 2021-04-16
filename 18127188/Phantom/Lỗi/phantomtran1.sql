begin tran
exec ttkh_view N'Nguyen Van D'
waitfor delay '00:00:04'
exec ttkh_view N'Nguyen Van D'
commit tran

