DECLARE @ID_Nha NCHAR(6) = 'CH0008'DECLARE @RT INTSELECT * FROM NHA WHERE nha_id = @ID_NhaEXEC @RT = NV_LapHopDong @MaKH = 7,
    @MaChuNha = 1,
    @MaNha = @ID_Nha, 
    @NgayThueBan = '2020-11-4', 
    @NgayHetHan = '2021-1-4' 
IF @RT = 1	PRINT N'LẬP HỢP ĐỒNG THẤT BẠI'ELSE	PRINT N'LẬP HỢP ĐỒNG THÀNH CÔNG'SELECT * FROM NHA WHERE nha_id = @ID_NhaSELECT * FROM HOP_DONG where hd_idnha = @ID_Nha