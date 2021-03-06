create procedure ttkh_delete( @kh_id int)
as
begin tran
	set tran isolation level serializable
	if not exists (select *from KHACH_HANG with (Updlock) where kh_id=@kh_id)
	begin 
		print N'Khach Hang' + cast(@kh_id as varchar(3)) + N'Khong ton tai'
		rollback tran
		return 1
	end
	waitfor delay '00:00:15'
	begin try
		delete from KHACH_HANG where kh_id=@kh_id
		SELECT RESOURCE_TYPE,DB_NAME(RESOURCE_DATABASE_ID)
		NAME,REQUEST_SESSION_ID,REQUEST_MODE,REQUEST_STATUS
		FROM SYS.DM_TRAN_LOCKS
	end try 
	begin catch
		DECLARE @ErrorMsg VARCHAR(2000)
		SELECT @ErrorMsg = N'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16,1)
		ROLLBACK TRAN
		return 1
	end catch
commit tran
return 0

--Dùng trước khi chạy lại 2 tran
INSERT INTO KHACH_HANG(kh_id,kh_ten,kh_dchi,kh_sdt,kh_idcn)
	VALUES 	  (13,N'Nguyễn Lam Linh',N'41 Quách Vũ, Phường Hiệp Tân, Quận Tân Phú, TP HCM','0941455123','CN0001')
--drop proc ttkh_delete