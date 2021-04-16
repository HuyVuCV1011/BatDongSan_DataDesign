create procedure TimKiemKhuVuc
(
	@KVuc as nvarchar(15)
)
as
set tran isolation level repeatable read
begin
	if not exists (select nha_id 
					from NHA	
					where nha_kvuc like @KVuc)
	begin
	print N'Không có nhà phù hợp yêu cầu'
	return 1
	end
	
	select nh.nha_id, nh.nha_slphong, nh.nha_ttrang ,nh.nha_duong, nh.nha_quan, nh.nha_tp, nh.nha_kvuc, nh.nha_idloai
	from NHA nh
	where nh.nha_kvuc like @KVuc
end;
--drop procedure TimKiemKhuVuc
create procedure ttnha_delete( @nha_id char(6))
as
begin tran
	begin try
		if not exists (select *from NHA where nha_id=@nha_id)
		begin 
			print N'Nha' + cast(@nha_id as varchar(6)) + N'Khong ton tai'
			rollback tran
			return 1
		end
		delete from NHA where nha_id=@nha_id
	end try 
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
	
commit tran
return 0
go