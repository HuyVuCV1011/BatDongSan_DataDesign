create  procedure TimKiemGiaBanTangDan
(
	@Gia as float
)
as
begin tran
	begin try
	select *
	from NHA
	where @Gia < nha_giab
	WAITFOR DELAY '0:0:15'
	end try
	begin catch
		print N'Lỗi hệ thống'
		ROLLBACK TRAN
		RETURN 1	
	END CATCH
COMMIT TRAN
RETURN 0
GO
--drop procedure TimKiemGiaBanTangDan
GO
create procedure ttnha__insert(
@nha_id char(6),
@nha_slphong int,
@nha_ttrang nvarchar(25),
@nha_duong nvarchar(30),
@nha_quan nvarchar(15),
@nha_kvuc nvarchar(15),
@nha_tp nvarchar(15),
@nha_giat float,
@nha_giab float,
@nha_dkban nvarchar(100),
@nha_idloai char(2),
@nha_idchu int,
@nha_idcn char(6),
@nha_idnv int,
@nha_ndang date,
@nha_hethan date)


as
begin tran
	begin try 
		if exists(select * from NHA where nha_id=@nha_id)
		begin 
			print N'Nha' + cast(@nha_id as varchar(6)) + N' Đã Tồn Tại'
			rollback tran
			return 1
		end 
		if @nha_idloai is null or @nha_idloai = ''
		begin 
			print N'Loai Nha Không Được Trống'
			rollback tran
			return 1
		end
		if @nha_idchu is null or @nha_idchu = ''
		begin 
			print N'Chủ nhà không được bỏ trống'
			rollback tran
			return 1
		end
		if @nha_idcn is null or @nha_idcn = ''
		begin 
			print N'ID Chi nhánh không được bỏ trống'
			rollback tran
			return 1
		end
		if @nha_idnv is null or @nha_idnv = ''
		begin 
			print N'ID Nhân viên không được bỏ trống'
			rollback tran
			return 1
		end
		if @nha_slphong is null or @nha_slphong = ''
		begin 
			print N'So Luong Phong Không Được Trống'
			rollback tran
			return 1
		end
		if @nha_ttrang is null or @nha_ttrang = ''
		begin 
			print N'Tinh Trang Nha Không Được Trống'
			rollback tran
			return 1
		end
		if @nha_duong is null or @nha_duong = ''
		begin 
			print N'Dia Chi Không Được Trống'
			rollback tran
			return 1
		end
		if @nha_quan is null or @nha_quan = ''
		begin 
			print N'Dia Chi Không Được Trống'
			rollback tran
			return 1
		end
		if @nha_kvuc is null or @nha_kvuc = ''
		begin 
			print N'Dia Chi Không Được Trống'
			rollback tran
			return 1
		end
		insert into NHA (nha_id,nha_slphong,nha_ttrang,nha_duong,nha_quan,nha_kvuc,nha_tp,nha_giat,nha_giab,nha_dkban,nha_idloai,nha_idchu,nha_idcn,nha_idnv,nha_ndang,nha_hethan)
		values (@nha_id,@nha_slphong,@nha_ttrang,@nha_duong,@nha_quan,@nha_kvuc,@nha_tp,@nha_giat,@nha_giab,@nha_dkban,@nha_idloai,@nha_idchu,@nha_idcn,@nha_idnv,@nha_ndang,@nha_hethan)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go