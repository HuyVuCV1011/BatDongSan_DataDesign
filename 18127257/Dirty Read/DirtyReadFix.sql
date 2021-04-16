create procedure ttnha__update(
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
		if  not exists(select * from NHA where nha_id=@nha_id)
		begin 
			print N'Nha' + cast(@nha_id as varchar(6)) + N' Khong Tồn Tại'
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

		update NHA
		set 
			nha_slphong=@nha_slphong,
			nha_ttrang=@nha_ttrang,
			nha_duong=@nha_duong,
			nha_quan=@nha_quan,
			nha_kvuc=@nha_kvuc,
			nha_tp=@nha_tp,
			nha_giat=@nha_giat,
			nha_giab=@nha_giab,
			nha_dkban=@nha_dkban,
			nha_idloai=@nha_idloai,
			nha_idchu=@nha_idchu,
			nha_idcn=@nha_idcn,
			nha_idnv=@nha_idnv,
			nha_ndang=@nha_ndang,
			nha_hethan=@nha_hethan
			where nha_id=@nha_id
		WAITFOR DELAY '00:00:10'
		if @nha_ndang > GETDATE() 
		begin
			print N'Lỗi'
			rollback tran
			return 1 
		end
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go


--NV xem nhà
create proc NV_Xem_Nha(@nha_id char(6))
as
--SET TRAN ISOLATION LEVEL READ UNCOMMITTED
begin tran
	begin try
		select * from NHA where nha_id = @nha_id
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go

--drop proc NV_Xem_Nha
--drop proc ttnha__update