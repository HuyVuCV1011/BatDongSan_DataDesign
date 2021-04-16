--create 
alter PROCEDURE ttkh__insert(@kh_id int, @kh_ten nvarchar(30), @kh_dchi nvarchar(100),@kh_sdt char(10),@kh_idcn char(6))
as
begin tran
	begin try 
		if exists(select * from KHACH_HANG where kh_id=@kh_id)
		begin 
			print N'Khach hang' + cast(@kh_id as varchar(3)) + N' Đã Tồn Tại'
			rollback tran
			return 1
		end 
		if @kh_ten is null or @kh_ten = ''
		begin 
			print N'Tên Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		IF LEN(@kh_sdt) <> 10
		begin 
			print N'SDT Không Hợp Lệ'
			rollback tran
			return 1
		end
		if @kh_dchi is null or @kh_ten = ''
		begin 
			print N'Dia Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		if not exists(select * from dbo.CHI_NHANH where cn_id=@kh_idcn)
		begin 
			print N'Chi Nhánh '+ @kh_idcn + N' Không Tồn Tại'
			rollback tran
			return 1
		end
		insert into dbo.KHACH_HANG (kh_id,kh_ten,kh_dchi,kh_sdt,kh_idcn)
		values (@kh_id,@kh_ten,@kh_dchi,@kh_sdt,@kh_idcn)

		if @kh_ten in (select kh_ten from KHACH_HANG where kh_idcn = @kh_idcn)
		begin
			WAITFOR DELAY '00:00:05'
			rollback tran
			return 1
		end
	end try
	begin CATCH
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go

--CREATE 
ALTER PROC NV_XemThongTinKhachHang
(
	@MaKH INT
)
AS
--SET TRAN ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN 
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM KHACH_HANG WHERE kh_id = @MaKH)
		BEGIN
			PRINT 'KH' + CAST(@MaKH AS VARCHAR(3)) + N' Không Tồn Tại'
			ROLLBACK TRAN 
			RETURN 
		END

		SELECT kh_id 'Mã khách hàng',kh_ten 'Tên Khách Hàng',kh_sdt 'SĐT',kh_dchi 'Địa Chỉ' 
		FROM KHACH_HANG
		WHERE kh_id = @MaKH

	END TRY 
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 	
	END CATCH
COMMIT TRAN
GO