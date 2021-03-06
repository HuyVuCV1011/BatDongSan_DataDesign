CREATE PROC upd_nxet
(
	@idnha char(6),
	@idkh int,
	@nxet nvarchar(50)
)
as
begin tran
	set tran isolation level serializable
	declare @check date = (select n.nha_hethan from NHA n where n.nha_id = @idnha);
	if (@check < GETDATE() or @check = null)
	begin
		raiserror (N'Đã hết hạn đăng của nhà hoặc nhà không tồn tại', 16, 0)
		rollback
		return 1
	end
	waitfor delay '00:00:15'
	begin try
		UPDATE XEM_NHA SET x_nxet = @nxet WHERE x_idnha = @idnha and x_idkh = @idkh
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
--exec upd_nxet 'CH0001', 7, N'Đẹp'
GO
CREATE PROC CapNhatLuotXem
(
	@idnha char(6),
	@idkh int
)
as
begin tran
	set tran isolation level serializable
	begin try
		if exists (select * from XEM_NHA xn with(nolock) where xn.x_idkh = @idkh and xn.x_idnha = @idnha)
		begin
			declare @dem int = (select COUNT(x_idnha) from XEM_NHA xn with(nolock) where xn.x_idnha = @idnha)
			UPDATE NHA SET nha_luotxem = @dem where nha_id = @idnha
		end
		else
			UPDATE NHA SET nha_luotxem = 0 where nha_id = @idnha
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
--drop proc upd_nxet
--drop proc CapNhatLuotXem