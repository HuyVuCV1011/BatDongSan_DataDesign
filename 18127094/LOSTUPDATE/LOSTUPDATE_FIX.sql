--Sua thong tin nha
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
AS
SET TRAN ISOLATION LEVEL REPEATABLE READ
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
		WAITFOR DELAY '00:00:05'
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
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go

CREATE PROC NV_LapHopDong
(
	@MaKH INT,
	@MaChuNha INT,
	@MaNha CHAR(6),
	@NgayThueBan DATE,
	@NgayHetHan DATE 
)
AS
BEGIN TRAN
	BEGIN TRY 
		DECLARE @MaHD CHAR(6) = dbo.AUTO_IDHD()
		DECLARE @LoaiHD NVARCHAR(6) = N'Thuê'
		DECLARE @ThoiGianThue INT
		DECLARE @TongTien FLOAT 
		IF (@NgayHetHan IS NULL) 
			SET @LoaiHD = N'Bán'

		IF (@LoaiHD = N'Bán')
			BEGIN
				SET @TongTien = (SELECT nha_giab FROM NHA WHERE nha_id=@MaNha) 
			END 
		ELSE
			BEGIN 
				SET @ThoiGianThue = DATEDIFF(MONTH,@NgayThueBan,@NgayHetHan) 
				SET @TongTien = (SELECT nha_giat * @ThoiGianThue FROM NHA WHERE nha_id=@MaNha) 
			END 
		IF NOT EXISTS(SELECT * FROM KHACH_HANG WHERE kh_id=@MaKH)
		BEGIN
			PRINT N'Khách Hàng ' + CAST(@MaKH AS VARCHAR(3)) + ' Chưa Có Trong Danh Sách Khách Hàng'
			ROLLBACK TRAN 
			RETURN 1
		END
		IF (@MaKH = @MaChuNha)
		BEGIN
			PRINT N'Khách Hàng ' + CAST(@MaKH AS VARCHAR(3)) + ' Không Hợp Lệ Vì Đây Là Chủ Nhà'
			ROLLBACK TRAN 
			RETURN 1
		END
		IF @MaKH NOT IN (SELECT x_idkh FROM XEM_NHA WHERE x_idnha = @MaNha)
		BEGIN
			PRINT N'Khách Hàng ' + CAST(@MaKH AS VARCHAR(3)) + N' Chưa Xem Nhà'
			ROLLBACK TRAN 
			RETURN 1
		END
		IF NOT EXISTS(SELECT * FROM NHA WHERE nha_id=@MaNha AND nha_idchu=@MaChuNha)
		BEGIN
			PRINT N'Thông Tin Chủ Nhà Và Nhà Không Hợp Lệ'
			ROLLBACK TRAN 
			RETURN 1
		END
		IF (SELECT nha_ttrang FROM NHA WHERE nha_id = @MaNha) IN (N'Đã cho thuê',N'Đã bán')
		BEGIN
			PRINT N'Nhà đã được cho thuê/bán'
			ROLLBACK TRAN 
			RETURN 1
		END 
		IF (@NgayThueBan < (SELECT nha_ndang FROM NHA WHERE nha_id=@MaNha) OR @NgayThueBan > (SELECT nha_hethan FROM NHA WHERE nha_id=@MaNha) OR @NgayThueBan < (SELECT x_ngxem FROM XEM_NHA WHERE x_idkh = @MaKH AND x_idnha = @MaNha))
		BEGIN
			PRINT N'Ngày Lập Hợp Đồng Không Hợp Lệ'
			ROLLBACK TRAN 
			RETURN 1
		END	
		IF (@NgayHetHan <= @NgayThueBan OR DAY(@NgayHetHan) <> DAY(@NgayThueBan))
		BEGIN
			PRINT N'Ngày Hết Hạn Hợp Đồng Không Hợp Lệ'
			ROLLBACK TRAN 
			RETURN 1
		END	
		INSERT INTO HOP_DONG(hd_id,hd_idchu,hd_idnha,hd_idkh,hd_ngay,hd_ngayhethan,hd_loai,hd_tongtien)
		VALUES(@MaHD,@MaChuNha,@MaNha,@MaKH,@NgayThueBan,@NgayHetHan,@LoaiHD,@TongTien)
		IF @LoaiHD = N'Thuê'
			UPDATE NHA SET nha_ttrang = N'Đã cho thuê' WHERE nha_id = @MaNha
		IF @LoaiHD = N'Bán'
		BEGIN 
			UPDATE NHA SET nha_ttrang = N'Đã bán' WHERE nha_id = @MaNha
			UPDATE NHA SET nha_idchu = @MaKH WHERE nha_id = @MaNha
		END 
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH 
COMMIT TRAN 
RETURN 0
GO
