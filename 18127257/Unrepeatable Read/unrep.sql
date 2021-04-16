--tìm kiếm nhân viên

create procedure TimKiemNhanVien
(
	@Ma_nv int
)
as
begin tran
	begin try
		if not exists (select *
						from NHAN_VIEN 	
						where nv_id like @Ma_nv )
		begin
			print N'Không có nhân viên phù hợp yêu cầu'
			rollback tran
			return 1
		end
	
		select *
		from NHAN_VIEN 
		where nv_id = @Ma_nv
	WAITFOR DELAY '00:00:05'
	rollback tran
	return 1
	end try

	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go

--admin xóa nhân viên

create PROC AD_XoaNhanVien
(
	@MaNV int 
)
AS 
BEGIN TRAN 
	BEGIN TRY 
		IF NOT EXISTS (SELECT * FROM NHAN_VIEN WHERE nv_id=@MaNV)
		BEGIN 
			PRINT N'NV' + CAST(@MaNV AS VARCHAR(3)) + N' Không Tồn Tại'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF EXISTS (SELECT * FROM NHA WHERE nha_idnv = @MaNV)
		BEGIN 
			PRINT N'NV' + CAST(@MaNV AS VARCHAR(3)) + N' Đã Thực Hiện Đăng Nhà, Không Xóa Được'
			ROLLBACK TRAN
			RETURN 1
		END 
		DELETE FROM NHAN_VIEN WHERE nv_id = @MaNV
	END TRY 
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH 
COMMIT TRAN 
RETURN 0
GO 

drop proc TimKiemNhanVien
drop proc AD_XoaNhanVien