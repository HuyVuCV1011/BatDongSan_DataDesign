﻿DECLARE @ID_Nha NCHAR(6) = 'CH0008'DECLARE @RT INTSELECT * FROM NHA WHERE nha_id = @ID_NhaEXEC @RT = ttnha__update @ID_Nha,6,N'Còn trống',N'Đường số 16',N'Quận 7',N'Trung tâm',N'TP HCM',52000000.0,NULL,NULL,'CH',1,'CN0002',3,'2020-10-20','2020-11-20'IF @RT = 1	PRINT N'CẬP NHẬT THẤT BẠI'ELSE	PRINT N'CẬP NHẬT THÀNH CÔNG'SELECT * FROM NHA WHERE nha_id = @ID_Nha