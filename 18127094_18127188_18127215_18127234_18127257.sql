--drop database QLBTN
CREATE DATABASE QLBTN
GO
USE QLBTN
GO
CREATE TABLE CHI_NHANH
(
	cn_id char(6),
	cn_sdt char(11) not null,
	cn_fax char(11),
	cn_duong nvarchar(30),
	cn_quan nvarchar(15),
	cn_kvuc nvarchar(15),
	cn_tp nvarchar(15),
	PRIMARY KEY(cn_id)
)
GO
CREATE TABLE NHAN_VIEN
(
	nv_id int,
	nv_ten nvarchar(30),
	nv_dchi nvarchar(100),
	nv_sdt char(10),
	nv_nsinh date,
	nv_gtinh nvarchar(3),
	nv_luong float, 
	nv_idcn char(6),
	PRIMARY KEY(nv_id)
)
GO
CREATE TABLE LOAI_NHA
(
	l_id char(2),
	l_ten nvarchar(15),
	PRIMARY KEY(l_id)
)
GO
CREATE TABLE NHA
(
	nha_id char(6),
	nha_slphong int, 
	nha_ttrang nvarchar(25),
	nha_duong nvarchar(30),
	nha_quan nvarchar(15),
	nha_kvuc nvarchar(15), 
	nha_tp nvarchar(15),
	nha_giat float,
	nha_giab float,
	nha_dkban nvarchar(100),
	nha_idloai char(2),
	nha_idchu int,
	nha_idcn char(6),
	nha_idnv int,
	nha_ndang date,
	nha_hethan date,
	nha_luotxem int default 0,
	PRIMARY KEY(nha_id)
)
GO
CREATE TABLE KHACH_HANG 
(
	kh_id int,
	kh_ten nvarchar(30),
	kh_dchi nvarchar(100),
	kh_sdt char(10) not null,
	kh_idcn char(6),
	PRIMARY KEY(kh_id)
)
GO
CREATE TABLE YEUCAU_KH
(
	yc_idkh int,
	yc_slphong int,
	yc_duong nvarchar(15),
	yc_quan nvarchar(15),
	yc_tp nvarchar(15),
	yc_kvuc nvarchar(15),
	yc_idloai char(2),
	PRIMARY KEY(yc_idkh)
)
GO
CREATE TABLE XEM_NHA
(
	x_idkh int,
	x_idnha char(6),
	x_ngxem date,
	x_nxet nvarchar(50),
	PRIMARY KEY(x_idkh, x_idnha)
)
GO
CREATE TABLE HOP_DONG
(
	hd_id char(6),
	hd_idchu int,
	hd_idnha char(6),
	hd_idkh int,
	hd_ngay date,
	hd_ngayhethan DATE,
	hd_loai nvarchar(6),
	hd_tongtien FLOAT,
	PRIMARY KEY(hd_id)
)
GO 
CREATE TABLE TAI_KHOAN_KH
(
	tkkh_idkh int,
	tkkh_tentk varchar(15) not null,
	tkkh_mk varchar(15) not null,
	PRIMARY KEY(tkkh_idkh)
)
GO
CREATE TABLE TAI_KHOAN_NV
(
	tknv_idnv int,
	tknv_tentk varchar(15) not null,
	tknv_mk varchar(15) not null,
	PRIMARY KEY (tknv_idnv)
)

ALTER TABLE NHAN_VIEN
ADD CONSTRAINT FK_NHANVIEN_CHINHANH
FOREIGN KEY (nv_idcn) REFERENCES CHI_NHANH(cn_id)
GO

ALTER TABLE NHA
ADD CONSTRAINT FK_NHA_LOAINHA
FOREIGN KEY (nha_idloai) REFERENCES LOAI_NHA(l_id)
GO

ALTER TABLE NHA
ADD CONSTRAINT FK_NHA_KHACHHANG_idcnha
FOREIGN KEY (nha_idchu) REFERENCES KHACH_HANG(kh_id)
GO

ALTER TABLE NHA
ADD CONSTRAINT FK_NHA_CHINHANH
FOREIGN KEY (nha_idcn) REFERENCES CHI_NHANH(cn_id)
GO

ALTER TABLE NHA
ADD CONSTRAINT FK_NHA_NHANVIEN
FOREIGN KEY (nha_idnv) REFERENCES NHAN_VIEN(nv_id)
GO
	
ALTER TABLE KHACH_HANG
ADD CONSTRAINT FK_KHACHHANG_CHINHANH
FOREIGN KEY (kh_idcn) REFERENCES CHI_NHANH(cn_id)
GO

ALTER TABLE YEUCAU_KH
ADD CONSTRAINT FK_YEUCAUKH_LOAINHA
FOREIGN KEY (yc_idloai) REFERENCES LOAI_NHA(l_id)
GO

ALTER TABLE XEM_NHA
ADD CONSTRAINT FK_XEMNHA_KHACHHANG
FOREIGN KEY (x_idkh) REFERENCES KHACH_HANG(kh_id) ON DELETE CASCADE
GO

ALTER TABLE XEM_NHA
ADD CONSTRAINT FK_XEMNHA_NHA
FOREIGN KEY (x_idnha) REFERENCES NHA(nha_id) ON DELETE CASCADE
GO

ALTER TABLE HOP_DONG
ADD CONSTRAINT FK_HOPDONG_KHACHHANG_idchu
FOREIGN KEY (hd_idchu) REFERENCES KHACH_HANG(kh_id) ON DELETE SET NULL
GO

ALTER TABLE HOP_DONG
ADD CONSTRAINT FK_HOPDONG_NHA
FOREIGN KEY (hd_idnha) REFERENCES NHA(nha_id) ON DELETE NO ACTION
GO

ALTER TABLE HOP_DONG
ADD CONSTRAINT FK_HOPDONG_KHACHHANG
FOREIGN KEY (hd_idkh) REFERENCES KHACH_HANG(kh_id) ON DELETE NO ACTION
GO
ALTER TABLE TAI_KHOAN_KH
ADD CONSTRAINT FK_TAIKHOANKH_KHACHHANG
FOREIGN KEY (tkkh_idkh) REFERENCES KHACH_HANG(kh_id) ON DELETE CASCADE
GO
ALTER TABLE TAI_KHOAN_NV
ADD CONSTRAINT FK_TAIKHOANNV_NHANVIEN
FOREIGN KEY (tknv_idnv) REFERENCES NHAN_VIEN(nv_id) ON DELETE CASCADE
GO
---
alter table NHAN_VIEN
add constraint kiemTraGioiTinh check(nv_gtinh='Nam' or nv_gtinh=N'Nữ')
go

alter table NHAN_VIEN
add constraint kiemTraLuong check(nv_luong >0)
go

alter table NHAN_VIEN
add constraint kiemTraNS check(DATEDIFF(yyyy,nv_nsinh,getdate())>18)
go

alter table NHA
add constraint kiemTraGiaBanThue check(nha_giat < nha_giab and nha_giat >0 and nha_giab >0 )

alter table NHA
add constraint kiemTraNgay check(nha_ndang < nha_hethan and DATEDIFF(day,nha_ndang,getdate()) >= 0)
go
alter table XEM_NHA
add constraint ngayXemNha check(DATEDIFF(day,x_ngxem,getdate()) >=0)
alter table HOP_DONG
add constraint ngayLapHD check(DATEDIFF(day,hd_ngay,getdate()) >=0)

alter table NHA
add constraint kiemTraSLPhong check(nha_slphong >0)
go

alter table YEUCAU_KH
add constraint yeuCauKH check(yc_slphong >0)
go

alter table CHI_NHANH
add constraint sdtU unique(cn_sdt)
go

alter table CHI_NHANH
add constraint faxU unique(cn_fax)
go

alter table NHAN_VIEN
add constraint sdtNV unique(nv_sdt)
go

alter table KHACH_HANG
add constraint sdtKH unique(kh_sdt)
GO

ALTER TABLE HOP_DONG
ADD CONSTRAINT NgayHetHan CHECK (hd_ngayhethan > hd_ngay)
GO 

ALTER TABLE HOP_DONG
ADD CONSTRAINT kiemTraKHHopLe CHECK (hd_idchu <> hd_idkh)
GO

alter table TAI_KHOAN_KH
add constraint UN_tkkh_tentk unique(tkkh_tentk)
go
alter table TAI_KHOAN_NV
add constraint UN_tknv_tentk unique(tknv_tentk)
go
--DATA
INSERT INTO CHI_NHANH(cn_id,cn_sdt,cn_fax,cn_duong,cn_quan,cn_kvuc,cn_tp)
	VALUES ('CN0001','02839102522','02837360357',N'Đường số 10',N'Quận 2',N'Trung tâm','TP HCM'),
		   ('CN0002','02838207779','02843678661',N'Đường 2B',N'Quận 7',N'Trung tâm','TP HCM'),
		   ('CN0003','02822200947','02822220788',N'Tô Hiến Thành',N'Quận 10',N'Trung tâm','TP HCM'),
		   ('CN0004','02868553333','02868553333',N'Nguyễn Văn Đồng',N'Thủ Đức',N'Ngoại ô','TP HCM')
GO

INSERT INTO NHAN_VIEN(nv_id,nv_ten,nv_dchi,nv_sdt,nv_nsinh,nv_gtinh,nv_luong,nv_idcn)
	VALUES (1,N'Nguyễn Hoài Nam',N'120 Lê Lai, Phường Phạm Ngũ Lão, Quận 1, TP HCM','0386124516','1990-01-01',N'Nam',10000000.0,'CN0001'),
		   (2,N'Nguyễn Hoàng Minh',N'551 Bình Thới, Phường 10, Quận 11, TP HCM','0324515614','1991-10-20',N'Nam',9500000.0,'CN0002'),
		   (3,N'Trần Hoàng Ngân',N'551/1A Lạc Long Quân, phường 10, Quận Tân Bình, TP HCM','0912345146','1992-03-10',N'Nữ',9000000.0,'CN0002'),
		   (4,N'Nguyễn Ngọc Ánh',N'12/21 Võ Văn Ngân, Phường Linh Tây, Quận Thủ Đức, TP HCM','0934151615','1995-04-12',N'Nữ',8000000.0,'CN0001'),
		   (5,N'Hà Văn Tùng',N'2 Trần Bình Trọng, Phường 5, Quận Bình Thạnh, TP HCM','0914151616','1993-05-11',N'Nam',11000000.0,'CN0003'),
		   (6,N'Ngô Ái Vân',N'412 Trần Hưng Đạo, Phường 2, Quận 5, TP HCM','0945235634','1994-03-11',N'Nữ',9000000.0,'CN0003'),
		   (7,N'Nguyễn Việt Hoàng',N'512/27 Trường Chinh, phường 13, Quận Tân Bình, TP HCM','0915263532','1992-06-01',N'Nam',12000000.0,'CN0001'),
		   (8,N'Lê Hoàng Long',N'224 Điện Biên Phủ, Phường 7, Quận 3, TP HCM','0903526333','1991-05-15',N'Nam',14000000.0,'CN0002'),
		   (9,N'Mai Trúc Linh',N'421/8 Sư Vạn Hạnh. Phường 12, Quận 10, TP HCM','0962323552','1988-02-11',N'Nữ',20000000.0,'CN0004'),
		   (10,N'Lâm Minh Tuyền',N'312 Tăng Nhơn Phú,Phường Tăng Nhơn Phú B, Quận 9, TP HCM','0935627223','1993-07-25',N'Nữ',11000000.0,'CN0004')
GO

INSERT INTO LOAI_NHA(l_id,l_ten)
	VALUES ('CH',N'Căn hộ'),
		   ('MP',N'Nhà mặt phố'),
		   ('BT',N'Biệt thự')
GO

INSERT INTO KHACH_HANG(kh_id,kh_ten,kh_dchi,kh_sdt,kh_idcn)
	VALUES (1,N'Nguyễn Hoài An',N'25/3 Lạc Long Quân, Q.10,TP HCM','0903123123','CN0002'),
		   (2,N'Trần Bạch Tuyết',N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM','0937888888','CN0001'),
		   (3,N'Trần Trà Hương',N'221 Hùng Vương,Q.5, TP HCM','0903656565','CN0001'),
		   (4,N'Phạm Nam Thanh',N'215 Lý Thường Kiệt,TP Biên Hòa, Đồng Nai','0913232323','CN0003'),
		   (5,N'Lý Hoàng Hà',N'125 Trần Hưng Đạo, Q.1, TP HCM','0388912112','CN0001'),
		   (6,N'Trần Trung Hiếu',N'22/11 Lý Thường Kiệt,TP Mỹ Tho, Tiền Giang','0931256943','CN0004'),
		   (7,N'Ngô Uyển Ân',N'221 Lê Trọng Tấn, Q.Tân Phú, TP HCM','0931256931','CN0002'),
		   (8,N'Huỳnh Trí Lâm',N'321 Nguyễn Đình Chiểu, Phường 6, Quận 3, TP HCM','0963416541','CN0001'),
		   (9,N'Trần Văn Minh',N'4 Nguyễn Bỉnh Khiêm, Phường ĐaKao, Quận 1, TP HCM','0911213574','CN0002'),
		   (10,N'Hoàng Ly Ly',N'122 Đường số 37, Phường Tân Quy, Quận 7, TP HCM','0934125612','CN0003'),
		   (11,N'Trịnh Văn Lâm',N'94 Trần Hưng Đạo, Phường Phạm Ngũ Lão, Quận 1, TP HCM','0916141124','CN0004'),
		   (12,N'Nguyễn Văn Phú',N'14 Trần Bình Trọng, Phường 1, Quận 5, TP HCM','0913412561','CN0002'),
		   (13,N'Nguyễn Lam Linh',N'41 Quách Vũ, Phường Hiệp Tân, Quận Tân Phú, TP HCM','0941455123','CN0001')
GO

INSERT INTO NHA(nha_id,nha_slphong,nha_ttrang,nha_duong,nha_quan,nha_kvuc,nha_tp,nha_giat,nha_giab,nha_dkban,nha_idloai,nha_idchu,nha_idcn,nha_idnv,nha_ndang,nha_hethan)
	VALUES ('CH0001',5,N'Đã bán',N'Nguyễn Văn Tưởng',N'Quận 7',N'Trung tâm',N'TP HCM',NULL,3800000000.0,N'Khách mua nhà gặp trực tiếp chủ nhà để thương lượng giá bán','CH',1,'CN0002',3,'2020-10-10','2020-11-24'),
		   ('CH0002',3,N'Đã cho thuê',N'Hưng Gia',N'Quận 7',N'Trung tâm',N'TP HCM',20000000.0,NULL,NULL,'CH',5,'CN0001',1,'2020-10-04','2020-11-18'),
		   ('CH0003',4,N'Còn trống',N'Bến Vân Đồn',N'Quận 4',N'Trung tâm',N'TP HCM',30000000.0,NULL,NULL,'CH',5,'CN0002',2,'2020-10-20','2020-11-20'),
		   ('CH0004',2,N'Còn trống',N'Nguyễn Duy Trinh',N'Quận 2',N'Trung tâm',N'TP HCM',15000000.0,NULL,NULL,'CH',3,'CN0001',4,'2020-10-21','2020-11-21'),
		   ('CH0005',4,N'Đã bán',N'Cao Lỗ',N'Quận 8',N'Trung tâm',N'TP HCM',NULL,2100000000.0,N'Khách hàng có nhu cầu vui lòng liên hệ Linh (chủ nhà) qua SĐT 0941455123','CH',6,'CN0001',7,'2020-10-22','2020-11-22'),
		   ('CH0006',4,N'Còn trống',N'Nguyễn Xiễn',N'Quận 9',N'Ngoại ô',N'TP HCM',15000000.0,NULL,NULL,'CH',1,'CN0003',5,'2020-10-12','2020-11-12'),
		   ('CH0007',3,N'Còn trống',N'Thủy Lợi',N'Quận 9',N'Ngoại ô',N'TP HCM',10000000.0,NULL,NULL,'CH',4,'CN0001',4,'2020-10-23','2020-11-23'),
		   ('CH0008',5,N'Còn trống',N'Đường số 16',N'Quận 7',N'Trung tâm',N'TP HCM',50000000.0,NULL,NULL,'CH',1,'CN0002',3,'2020-10-20','2020-11-20'),
		   ('MP0001',3,N'Đã cho thuê',N'Nguyễn Hữu Thọ',N'Nhà Bè',N'Ngoại ô',N'TP HCM',20000000.0,NULL,NULL,'MP',3,'CN0004',10,'2020-10-20','2020-11-20'),
		   ('MP0002',4,N'Còn trống',N'Võ Văn Kiệt',N'Quận 1',N'Trung tâm',N'TP HCM',40000000.0,NULL,NULL,'MP',2,'CN0001',1,'2020-10-18','2020-11-18'),
		   ('MP0003',3,N'Còn trống',N'Nam Thiên 1',N'Quận 7',N'Trung tâm',N'TP HCM',25000000.0,NULL,NULL,'MP',3,'CN0001',4,'2020-10-19','2020-11-19'),
		   ('MP0004',4,N'Còn trống',N'Lũy Bán Bích',N'Tân Phú',N'Trung tâm',N'TP HCM',30000000.0,NULL,NULL,'MP',1,'CN0002',5,'2020-10-21','2020-11-21'),
		   ('MP0005',4,N'Đã cho thuê',N'Phạm Văn Đồng',N'Thủ Đức',N'Ngoại ô',N'TP HCM',35000000.0,NULL,NULL,'MP',4,'CN0003',6,'2020-10-22','2020-11-22'),
		   ('MP0006',5,N'Còn trống',N'Đường số 5',N'Bình Chánh',N'Ngoại ô',N'TP HCM',50000000.0,NULL,NULL,'MP',4,'CN0001',7,'2020-10-23','2020-11-23'),
		   ('BT0001',4,N'Còn trống',N'Mỹ Phú 2',N'Quận 7',N'Trung tâm',N'TP HCM',50000000.0,NULL,NULL,'BT',6,'CN0002',8,'2020-10-20','2020-11-20'),
		   ('BT0002',3,N'Còn trống',N'Nam Long',N'Quận 7',N'Trung tâm',N'TP HCM',35000000.0,NULL,NULL,'BT',4,'CN0004',9,'2020-10-24','2020-11-24'),
		   ('BT0003',4,N'Còn trống',N'Nguyễn Hữu Thọ',N'Nhà Bè',N'Ngoại ô',N'TP HCM',34000000.0,NULL,NULL,'BT',1,'CN0001',1,'2020-10-23','2020-11-25'),
		   ('BT0004',4,N'Còn trống',N'Ngô Quang Thắm',N'Nhà Bè',N'Ngoại ô',N'TP HCM',25000000.0,NULL,NULL,'BT',2,'CN0002',3,'2020-10-23','2020-11-26'),
		   ('BT0005',5,N'Đã cho thuê',N'Thảo Điền',N'Quận 2',N'Trung tâm',N'TP HCM',45000000.0,NULL,NULL,'BT',4,'CN0001',4,'2020-10-23','2020-11-27'),
		   ('BT0006',4,N'Còn trống',N'Đường số 1',N'Quận 7',N'Trung tâm',N'TP HCM',36000000.0,NULL,NULL,'BT',5,'CN0002',8,'2020-10-21','2020-11-21')

GO

INSERT INTO YEUCAU_KH(yc_idkh,yc_slphong,yc_duong,yc_quan,yc_tp,yc_kvuc,yc_idloai)
	VALUES (7,NULL,NULL,N'Quận 7','TP HCM',N'Trung tâm','CH'),
		   (8,3,NULL,N'Nhà Bè','TP HCM',N'Ngoại ô','MP'),
		   (9,5,NULL,N'Quận 2','TP HCM',N'Trung tâm','BT'),
		   (10,4,NULL,N'Thủ Đức','TP HCM',N'Ngoại ô','MP'),
		   (11,4,NULL,N'Quận 8','TP HCM',N'Trung tâm','CH'),
		   (12,NULL,NULL,N'Quận 7','TP HCM',N'Trung tâm','CH'),
		   (13,NULL,NULL,NULL,'TP HCM',N'Ngoại ô','CH')
GO

INSERT INTO XEM_NHA(x_idkh,x_idnha,x_ngxem,x_nxet)
	VALUES (7,'CH0001','2020-10-25',N'Căn hộ tiện nghi, thoải mái'),
		   (7,'CH0008','2020-10-23',N'Căn hộ tiện nghi'),
		   (8,'MP0001','2020-10-27',N'Diện tích nhà rộng, thuận tiện đi lại'),
		   (9,'BT0005','2020-10-28',N'Nhà thông thoáng, bố trí phòng ốc hợp lý'),  
		   (10,'MP0005','2020-10-29',N'Vị trí nhà thuận tiện cho việc đi lại'),
		   (11,'CH0005','2020-10-30',N'Diện tích nhà hơi nhỏ'),
		   (12,'CH0001','2020-10-24',N'Nội thất được trang bị đầy đủ, tiện nghi'),
		   (12,'CH0002','2020-10-25',N'Nhà tương đối nhỏ'),
		   (12,'CH0008','2020-10-26',N'Gần trung tâm thành phố, thuận tiện đi lại'),
		   (13,'CH0007','2020-10-27',N'Nhà hơi xa trung tâm thành phố')
GO

INSERT INTO HOP_DONG(hd_id,hd_idchu,hd_idnha,hd_idkh,hd_ngay,hd_ngayhethan,hd_loai,hd_tongtien)
	VALUES ('HD0001',1,'CH0001',7,'2020-10-26',NULL,N'Bán',3800000000.0),
		   ('HD0002',4,'MP0005',10,'2020-10-30','2021-01-30',N'Thuê',35000000.0 * 3),
		   ('HD0003',5,'CH0002',12,'2020-10-27','2020-11-27',N'Thuê',20000000.0 * 1),
		   ('HD0004',6,'CH0005',11,'2020-10-28',NULL,N'Bán',2100000000.0),
		   ('HD0005',3,'MP0001',8,'2020-10-28','2020-11-28',N'Thuê',20000000.0 * 2),
		   ('HD0006',4,'BT0005',9,'2020-10-29','2021-01-29',N'Thuê',45000000.0 * 3)
GO

INSERT INTO TAI_KHOAN_KH (tkkh_idkh,tkkh_tentk,tkkh_mk)
	VALUES (1,'NGHOAIAN','0903123123'),
		   (2,'TRBACHTUYET','0937888888'),
		   (3,'TRTRAHUONG','0903656565'),
		   (4,'PHNAMTHANH','0913232323'),
		   (5,'LYHOANGHA','0388912112'),
	       (6,'TRTRUNGHIEU','0931256943'),
		   (7,'NGOUYENAN','0931256931'),
		   (8,'HTRILAM','0963416541'),
		   (9,'TRVANMINH','0911213574'),
		   (10,'HLYLY','0934125612'),
		   (11,'TRVANLAM','0916141124'),
		   (12,'NGVANPHU','0913412561'),
		   (13,'NGLAMLINH','0941455123')
GO
INSERT INTO TAI_KHOAN_NV (tknv_idnv,tknv_tentk,tknv_mk)
	VALUES (1,'NGHOAINAM','0386124516'),
		   (2,'NGHOANGMINH','0324515614'),
		   (3,'TRHOANGNGAN','0912345146'),
		   (4,'NGNGOCANH','0934151615'),
		   (5,'HAVANTUNG','0914151616'),
		   (6,'NGOAIVAN','0945235634'),
		   (7,'NGVIETHOANG','0915263532'),
		   (8,'LEHOANGLONG','0903526333'),
		   (9,'MAITRUCLINH','0962323552'),
		   (10,'LMINHTUYEN','0935627223')
GO
			
--drop database QLBTN
--ALL1

create  procedure TimKiemTG
(
	@TG as DATE
)
as
begin
	select *
	from DANG_NHA dn
	where @TG <= dn.nha_ndang
	order by dn.nha_ndang
end;

--drop procedure TimKiemTG
--exec TimKiemTG '2020-10-20'

--ALL5
GO
create  procedure TimKiemGiaBan
(
	@Gia as float
)
as
begin
	select *
	from NHA nh
	where @Gia = nh.nha_giab
end; 
GO
create  procedure TimKiemGiaBanTangDan
(
	@Gia as float
)
as
begin
	select *
	from NHA nh
	where @Gia < nh.nha_giab
	order by nh.nha_giab
end;
GO
create  procedure TimKiemGiaBanGiamDan
(
	@Gia as float
)
as
begin
	select *
	from NHA nh
	where @Gia > nh.nha_giab
	order by nh.nha_giab
end;
exec TimKiemGiaBan 2100000000.0
GO
create  procedure TimKiemGiaThue
(
	@Gia as float
)
as
begin
	select *
	from NHA nh
	where @Gia = nh.nha_giat
end;
GO
create  procedure TimKiemGiaThueTangDan
(
	@Gia as float
)
as
begin
	select *
	from NHA nh
	where @Gia < nh.nha_giat
	order by  nh.nha_giat
end;
GO
create  procedure TimKiemGiaThueGiamDan
(
	@Gia as float
)
as
begin
	select *
	from NHA nh
	where @Gia > nh.nha_giat
	order by  nh.nha_giat 
end;
exec TimKiemGiaThueGiamDan 30000000
GO
--ALL6
create  procedure TimKiemDuong
(
	@Duong as nvarchar(30)
)
as
begin
	select *
	from NHA nh
	where nh.nha_duong like  @Duong 
end;
--exec TimKiemDuong N'Nguyễn Văn Tưởng'
GO
create  procedure TimKiemQuan
(
	@Quan as nvarchar(15)
)
as
begin
	select *
	from NHA nh
	where nh.nha_quan like @Quan
end;
--exec TimKiemQuan N'Quận 7'
GO
create  procedure TimKiemKhuVuc
(
	@KVuc as nvarchar(15)
)
as
begin
	select *
	from NHA nh
	where nh.nha_kvuc like @KVuc
end;
--exec TimKiemKhuVuc N'Ngoại ô'
GO
create  procedure TimKiemTPho
(
	@TP as nvarchar(15)
)
as
begin
	select *
	from NHA nh
	where nh.nha_tp like @TP
end;
--exec TimKiemTPho N'TP HCM'
GO
--ALL2
create procedure TimKiemSlPhong
(
	@Sl as int
)
as
begin 
	select n.nha_id, n.nha_slphong, n.nha_ttrang, n.nha_duong, n.nha_quan, n.nha_kvuc, n.nha_tp, n.nha_giab, n.nha_giat, n.nha_dkban, n.nha_idloai
	from YEUCAU_KH yc, NHA n
	where yc.yc_slphong = @Sl and yc.yc_slphong = n.nha_slphong and n.nha_ttrang like N'Còn trống'

end;
--exec TimKiemSlPhong 3
GO
create procedure TimKiemYCDuong
(
	@Duong as nvarchar(30)
)
as
begin 
	select n.nha_id, n.nha_slphong, n.nha_ttrang, n.nha_duong, n.nha_quan, n.nha_kvuc, n.nha_tp, n.nha_giab, n.nha_giat, n.nha_dkban, n.nha_idloai
	from YEUCAU_KH yc, NHA n
	where yc.yc_duong like @Duong and n.nha_duong like yc.yc_duong and n.nha_ttrang like N'Còn trống'

end;
--Khong co du lieu de kiem tra 
exec TimKiemYCDuong N'Mỹ Phú 2'
GO
create procedure TimKiemYCQuan
(
	@Quan as nvarchar(30)
)
as
begin 
	select n.nha_id, n.nha_slphong, n.nha_ttrang, n.nha_duong, n.nha_quan, n.nha_kvuc, n.nha_tp, n.nha_giab, n.nha_giat, n.nha_dkban, n.nha_idloai
	from YEUCAU_KH yc, NHA n
	where yc.yc_quan like @Quan and n.nha_quan like yc.yc_quan and n.nha_ttrang like N'Còn trống'

end;
--exec TimKiemYCQuan N'Quận 7'
GO
create procedure TimKiemYCTP
(
	@TP as nvarchar(30)
)
as
begin 
	select n.nha_id, n.nha_slphong, n.nha_ttrang, n.nha_duong, n.nha_quan, n.nha_kvuc, n.nha_tp, n.nha_giab, n.nha_giat, n.nha_dkban, n.nha_idloai
	from YEUCAU_KH yc, NHA n
	where yc.yc_tp like @TP and n.nha_tp like yc.yc_tp and n.nha_ttrang like N'Còn trống'

end;
--exec TimKiemYCTP N'TP HCM'
GO
create procedure TimKiemYCKVuc
(
	@KVuc as nvarchar(30)
)
as
begin 
	select n.nha_id, n.nha_slphong, n.nha_ttrang, n.nha_duong, n.nha_quan, n.nha_kvuc, n.nha_tp, n.nha_giab, n.nha_giat, n.nha_dkban, n.nha_idloai
	from YEUCAU_KH yc, NHA n
	where yc.yc_kvuc like @Kvuc and n.nha_kvuc like yc.yc_kvuc and n.nha_ttrang like N'Còn trống'

end;
--exec TimKiemYCKVuc N'Trung tâm'
GO
create procedure TimKiemYCLoai
(
	@Loai as char(2)
)
as
begin 
	select n.nha_id, n.nha_slphong, n.nha_ttrang, n.nha_duong, n.nha_quan, n.nha_kvuc, n.nha_tp, n.nha_giab, n.nha_giat, n.nha_dkban, n.nha_idloai
	from YEUCAU_KH yc, NHA n
	where yc.yc_idloai like @Loai and n.nha_idloai like yc.yc_idloai and n.nha_ttrang like N'Còn trống'
end;
--exec TimKiemYCLoai 'CH'
GO
--ALL3
create procedure TimKiemCN
(
	@ID as char(6)
)
as
begin 
	if (@ID not in (select cn_id
					from CHI_NHANH))
		begin
		raiserror (N'Nhập sai mã chi nhánh !!! Mời nhập lại', 16, 0)
		rollback
		end
	else
	(
	select *
	from CHI_NHANH
	where cn_id like @ID
	)
end;
drop procedure TimKiemCN 
--exec TimKiemCN 'CN0003'
GO
--KH1
create function TimChiNhanhItKHNhat
()
RETURNS char(6)
as
begin

return (SELECT TOP(1) cn1.cn_id FROM CHI_NHANH cn1 left join KHACH_HANG kh1 on (cn1.cn_id = kh1.kh_idcn) GROUP BY cn1.cn_id HAVING COUNT(cn1.cn_id) <= all (SELECT COUNT(kh2.kh_idcn) FROM KHACH_HANG kh2 GROUP BY kh2.kh_idcn))

end
GO
create procedure TaoTaiKhoanKH
(
	@TenKH as nvarchar(30),
	@DiaChi as nvarchar(100),
	@SDT as char(10),
	@Taikhoan as varchar(15),
	@Mk as varchar(15)
)
as
begin
if (@TenKH = null or @DiaChi = null or @SDT = null)
	begin
	raiserror (N'Vui lòng nhập đầy đủ các trường bắt buộc', 16, 0)
	rollback
	end
if (@Taikhoan in (SELECT tkkh.tkkh_tentk FROM TAI_KHOAN_KH tkkh))
	begin
	raiserror (N'Tên tài khoản đã có, vui lòng nhập lại', 16, 0)
	rollback
	end
DECLARE @max_idkh int, @idcn char(6);
 
SET @max_idkh = (SELECT (MAX(tk.tkkh_idkh) + 1) FROM TAI_KHOAN_KH tk);
SET @idcn = dbo.TimChiNhanhItKHNhat();

INSERT INTO KHACH_HANG(kh_id,kh_ten,kh_dchi,kh_sdt,kh_idcn)
	VALUES (@max_idkh, @TenKH, @DiaChi, @SDT, @idcn)

INSERT INTO TAI_KHOAN_KH (tkkh_idkh,tkkh_tentk,tkkh_mk)
	VALUES (@max_idkh,@Taikhoan,@Mk)

end;
GO
--exec TaoTaiKhoanKH 'Quách Phú Thành','1688A Võ Văn Kiệt P.An Lạc Q.Bình Tân TPHCM','0707081602','QPHUTHANH','0707081602'
-------ADMIN
--AD2: thay doi khach hang: them, xoa, sua thong tin khach hang
-- Them thong tin khach hang




create procedure ttkh__insert(@kh_id int, @kh_ten nvarchar(30), @kh_dchi nvarchar(100),@kh_sdt char(10),@kh_idcn char(6))
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
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go
--exec  ttkh__insert 15,N'Nguyen Van C',N'HCM','1500235','CN0003'

--Sua thong tin khach hang
create procedure ttkh__update(@kh_id int, @kh_ten nvarchar(30), @kh_dchi nvarchar(100),@kh_sdt char(10),@kh_idcn char(6))
as
begin tran
	begin try 
		if not exists(select * from KHACH_HANG where kh_id=@kh_id)
		begin 
			print N'Khach hang' + cast(@kh_id as varchar(3)) + N' Khong Tồn Tại'
			rollback tran
			return 1
		end 
		if @kh_ten is null or @kh_ten = ''
		begin 
			print N'Tên Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		if @kh_dchi is null or @kh_ten = ''
		begin 
			print N'Dia Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		IF LEN(@kh_sdt) <> 10
		begin 
			print N'SDT Không Hợp Lệ'
			rollback tran
			return 1
		end
		if not exists(select * from dbo.CHI_NHANH where cn_id=@kh_idcn)
		begin 
			print N'Chi Nhánh '+ @kh_idcn + N' Không Tồn Tại'
			rollback tran
			return 1
		end
		update dbo.KHACH_HANG
		set 
			kh_ten=@kh_dchi,
			kh_sdt=@kh_sdt
		where kh_id=@kh_id
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go
--exec  ttkh__update 1,N'Nguyen Van C',N'HCM','1500235','CN0003'
--drop proc ttkh__update
--Xóa thong tin khach hang
create procedure ttkh_delete( @kh_id int)
as
begin tran
	begin try
		if not exists (select *from KHACH_HANG where kh_id=@kh_id)
		begin 
			print N'Khach Hang' + cast(@kh_id as varchar(3)) + N'Khong ton tai'
			rollback tran
			return 1
		end
		delete from KHACH_HANG where kh_id=@kh_id
	end try 
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
	
commit tran
return 0
go
--exec ttkh_delete 10
-- Xem thong tin khach hang
create procedure ttkh_view(@kh_ten nvarchar(30))
as
begin tran
	begin try
		if not exists (select *from KHACH_HANG where kh_ten=@kh_ten)
		begin 
			print N'Khach Hang' + N'Khong ton tai'
			rollback tran
			return 1
		end
		select * from KHACH_HANG where kh_ten=@kh_ten
	end try 
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go
--exec ttkh_view 2
---Them thong tin nha
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

--exec ttnha__insert 'BT0007',5,N'Còn trống',N'Đường số 1',N'Quận 7',N'Trung tâm',N'TP HCM',36000000.0,NULL,NULL,'BT',5,'CN0002',8,'2020-10-21','2020-11-21'
--drop proc ttnha__insert
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
		
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go
--exec ttnha__update  'BT0006',6,N'Còn trống',N'Đường số 1',N'Quận 7',N'Trung tâm',N'TP HCM',36000000.0,NULL,NULL,'BT',5,'CN0002',8,'2020-10-21','2020-11-21'
-- Xoa thong tin nha
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
--exec ttnha_delete 10
--xem thong tin nha
create procedure ttnha_view(@nha_id char(6))
as
begin tran
	begin try
		if not exists (select *from NHA where nha_id=@nha_id)
		begin 
			print N'Nha' + cast(@nha_id as varchar(6)) + N'Khong ton tai'
			rollback tran
			return 1
		end
		select * from NHA where nha_id=@nha_id
	end try 
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go
--drop proc ttnha_delete

--Thong ke so luong hop dong ky trong 1 ngay nhat dinh
create procedure thongke_slHD(@hd_ngay date)
as
begin tran
	begin try
		if not exists (select * from HOP_DONG where hd_ngay=@hd_ngay)
		begin 
			print N'Ngay khong ton tai'
			rollback tran
			return 1
		end
		begin 
		select COUNT(hd_ngay) as slHD,hd_loai,hd_ngay
		from HOP_DONG
		where hd_ngay=@hd_ngay
		group by hd_ngay,hd_loai,hd_ngay
		
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
--exec thongke_slHD'2020-10-28'
--drop proc thongke_slHD
--Thong ke so luong hop dong theo khoang thoi gian nhat dinh
create procedure thongke_slhdtheokhoanthoigian(@hd_ngay1 date,@hd_ngay2 date)
as
begin tran
	begin try
		if not exists (select * from HOP_DONG where hd_ngay=@hd_ngay1)
		begin 
			print N'Ngay khong ton tai'
			rollback tran
			return 1
		end
		if not exists (select * from HOP_DONG where hd_ngay=@hd_ngay2)
		begin 
			print N'Ngay khong ton tai'
			rollback tran
			return 1
		end
		begin 
		select COUNT(hd_ngay) as slHD,hd_loai,hd_ngay
		from HOP_DONG
		where DATEDIFF(DAY,@hd_ngay1,hd_ngay) >=0 and DATEDIFF(DAY,hd_ngay,@hd_ngay2) >=0
		group by hd_ngay,hd_loai,hd_ngay
		
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
--exec thongke_slhdtheokhoanthoigian '2020-10-26','2020-10-28'
--drop proc thongke_slhdtheokhoanthoigian
--Xem so thich cua khach hang

create procedure thongke_sothic1kh(@x_idkh int)
as
begin tran
	begin try
		if not exists (select * from YEUCAU_KH where yc_idkh=@x_idkh)
		begin 
			print N'Khong ton tai khach hang'
			rollback tran
			return 1
		end
		begin 
		select *
		from YEUCAU_KH
		where yc_idkh=@x_idkh
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
--exec thongke_sothic1kh 1
--drop proc thongke_sothickh

create procedure thongke_sothickh
as
begin tran
	begin try
		
		begin 
		select *
		from YEUCAU_KH
		
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
--exec thongke_sothickh 

---------NV04 ----> AD01 -------------------
--NV04: Lấy thông tin khách hàng
CREATE
--ALTER
 PROC NV_XemThongTinKhachHang
(
	@MaKH INT
)
AS
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

EXEC NV_XemThongTinKhachHang 2
GO
--NV05: Xếp lịch xem nhà
-- NV xem yêu cầu KH rồi điền vào các thông tin (kiểm tra lại xem có phù hợp với yêu cầu của KH không)--> Làm thủ công từng căn nhà cho từng KH
-- T k biết cách tự động xếp lịch nếu có nhiều nhà phù hợp yêu cầu nên làm theo cách cho NV điền vào 1 Mã Nhà rồi kiểm tra lại
CREATE
--ALTER
PROC NV_XepLichXemNha
(
	@MaKH INT,
	@MaNha CHAR(6),
	@NgayHenXem DATE 
)
AS 
BEGIN TRAN
	BEGIN TRY 
		IF NOT EXISTS(SELECT * FROM KHACH_HANG WHERE kh_id = @MaKH)
			BEGIN 
				PRINT N'KH' + CAST(@MaKH AS VARCHAR(3)) + N' Không Tồn Tại'
				ROLLBACK TRAN
				RETURN 1
			END
		IF @MaKH = (SELECT nha_idchu FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'KH' + CAST(@MaKH AS VARCHAR(3)) + N' Không Hợp Lệ Vì Đây Là Chủ Nhà'
				ROLLBACK TRAN
				RETURN 1
			END
		IF NOT EXISTS(SELECT * FROM YEUCAU_KH WHERE yc_idkh = @MaKH)
			BEGIN 
				PRINT N'KH' + CAST(@MaKH AS VARCHAR(3)) + N' Chưa Có Yêu Cầu Về Nhà Cần Xem'
				ROLLBACK TRAN
				RETURN 1
			END 
		IF NOT EXISTS(SELECT * FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N'Không Tồn Tại'
				ROLLBACK TRAN
				RETURN 1
			END
		IF (SELECT nha_ttrang FROM NHA WHERE nha_id = @MaNha) <> N'Còn trống'
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Đã Được Cho Thuê/Bán'
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (SELECT yc_idloai FROM YEUCAU_KH WHERE yc_idkh = @MaKH) <> (SELECT nha_idloai FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Không Đáp Ứng Yêu Cầu Về Loại Nhà Của Khách Hàng KH' + CAST(@MaKH AS VARCHAR(3))
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (SELECT yc_tp FROM YEUCAU_KH WHERE yc_idkh = @MaKH) IS NOT NULL AND (SELECT yc_tp FROM YEUCAU_KH WHERE yc_idkh = @MaKH) <> (SELECT nha_tp FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Không Đáp Ứng Yêu Cầu Về Thành Phố Của Khách Hàng KH' + CAST(@MaKH AS VARCHAR(3))
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (SELECT yc_kvuc FROM YEUCAU_KH WHERE yc_idkh = @MaKH) IS NOT NULL AND (SELECT yc_kvuc FROM YEUCAU_KH WHERE yc_idkh = @MaKH) <> (SELECT nha_kvuc FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Không Đáp Ứng Yêu Cầu Về Khu Vực Của Khách Hàng KH' + CAST(@MaKH AS VARCHAR(3))
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (SELECT yc_quan FROM YEUCAU_KH WHERE yc_idkh = @MaKH) IS NOT NULL AND (SELECT yc_quan FROM YEUCAU_KH WHERE yc_idkh = @MaKH) <> (SELECT nha_quan FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Không Đáp Ứng Yêu Cầu Về Quận Của Khách Hàng KH' + CAST(@MaKH AS VARCHAR(3))
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (SELECT yc_duong FROM YEUCAU_KH WHERE yc_idkh = @MaKH) IS NOT NULL AND (SELECT yc_duong FROM YEUCAU_KH WHERE yc_idkh = @MaKH) <> (SELECT nha_duong FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Không Đáp Ứng Yêu Cầu Về Đường Của Khách Hàng KH' + CAST(@MaKH AS VARCHAR(3))
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (SELECT yc_slphong FROM YEUCAU_KH WHERE yc_idkh = @MaKH) IS NOT NULL AND (SELECT yc_slphong FROM YEUCAU_KH WHERE yc_idkh = @MaKH) <> (SELECT nha_slphong FROM NHA WHERE nha_id = @MaNha)
			BEGIN 
				PRINT N'Nhà ' + @MaNha + N' Không Đáp Ứng Yêu Cầu Về Số Lượng Phòng Của Khách Hàng KH' + CAST(@MaKH AS VARCHAR(3))
				ROLLBACK TRAN
				RETURN 1
			END 
		IF (@NgayHenXem < (SELECT nha_ndang FROM NHA WHERE nha_id=@MaNha) OR @NgayHenXem > (SELECT nha_hethan FROM NHA WHERE nha_id=@MaNha))
		BEGIN
			PRINT N'Ngày Hẹn Xem Nhà Không Hợp Lệ'
			ROLLBACK TRAN 
			RETURN 1
		END	
		INSERT INTO XEM_NHA(x_idkh,x_idnha,x_ngxem,x_nxet )
		VALUES  (@MaKH,@MaNha,@NgayHenXem,NULL)
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH 
COMMIT TRAN 
RETURN 0
GO

EXEC NV_XepLichXemNha @MaKH = 13, -- int
    @MaNha = 'CH0006', -- char(6)
    @NgayHenXem = '2020-11-1' -- date
GO 
--DELETE FROM dbo.XEM_NHA WHERE x_idkh = 13 AND x_idnha = 'CH0006'

--NV06: Quản lý hợp đồng
--Ngày lập hợp đồng phải nằm trong khoảng thời gian đăng nhà
--Hàm tự động thêm mã hợp đồng
CREATE
--ALTER
FUNCTION AUTO_IDHD()
RETURNS VARCHAR(6)
AS
BEGIN
	DECLARE @ID VARCHAR(6)
	IF (SELECT COUNT(hd_id) FROM HOP_DONG) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(hd_id, 4)) FROM HOP_DONG
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'HD000' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 and @ID < 99 THEN 'HD00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 99 and @ID < 999 THEN 'HD0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 999 THEN 'HD' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)

		END
	RETURN @ID
END
GO 
---
CREATE
--ALTER
PROC NV_LapHopDong
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
	
EXEC NV_LapHopDong @MaKH = 7, -- int
    @MaChuNha = 1, -- int
    @MaNha = 'CH0008', -- char(6)
    @NgayThueBan = '2020-11-4', -- date
    @NgayHetHan = '2021-1-4' -- date
GO


--UPDATE NHA SET nha_ttrang = N'Còn trống' WHERE nha_id = 'CH0008'
--DELETE FROM dbo.HOP_DONG WHERE hd_id = 'HD0007'
--Quản lý hợp đồng 
CREATE 
--ALTER
PROC NV_QuanLyHopDongThue
(
	@MaHD CHAR(6)
)
AS
BEGIN TRAN
	BEGIN TRY 
	DECLARE @SoNgayConHD INT = DATEDIFF(DAY,GETDATE(),(SELECT hd_ngayhethan FROM HOP_DONG WHERE hd_id = @MaHD))
		IF NOT EXISTS(SELECT * FROM HOP_DONG WHERE hd_id = @MaHD)
		BEGIN
			PRINT N'Hợp đồng ' + @MaHD + N' Không Tồn Tại'
			ROLLBACK TRAN 
			RETURN 
		END	
		IF (SELECT hd_loai FROM HOP_DONG WHERE hd_id = @MaHD) = N'Thuê'
		BEGIN 
			IF @SoNgayConHD < 0
			BEGIN 
				UPDATE NHA SET nha_ttrang = N'Còn trống' WHERE nha_id = (SELECT hd_idnha FROM HOP_DONG WHERE hd_id = @MaHD)
				PRINT N'Hợp đồng thuê nhà ' + @MaHD + N' đã hết hạn'
			END 
			IF @SoNgayConHD BETWEEN 0 AND 30
				PRINT N'Hợp đồng thuê nhà ' + @MaHD + N' sắp hết hạn. Hãy liên hệ với khách hàng có muốn thuê tiếp hay không'
		END 
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 
	END CATCH 
	PRINT N'Hợp đồng thuê' + @MaHD + N' Còn ' + CAST(@SoNgayConHD AS VARCHAR(3)) + N' ngày nữa là hết hạn hợp đồng'
COMMIT TRAN 
RETURN 0
GO

EXEC NV_QuanLyHopDongThue @MaHD = 'HD0006' -- char(6)
GO

--AD1: Thay đổi nhân viên
--Thêm nhân viên
CREATE
--ALTER
PROC AD_ThemNhanVien
(
	@TenNV nvarchar(30),
	@DiaChi nvarchar(100),
	@SDT char(10),
	@NgaySinh date,
	@GT nvarchar(3),
	@Luong float, 
	@MaCN char(6)
)
AS
BEGIN TRAN
	BEGIN TRY 
		IF @TenNV IS NULL OR @TenNV = ''
		BEGIN 
			PRINT N'Tên Nhân Viên Không Được Trống'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF LEN(@SDT) <> 10
		BEGIN 
			PRINT N'SDT Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF DATEDIFF(YEAR,@NgaySinh,GETDATE()) < 18
		BEGIN 
			PRINT N'Ngày Sinh Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF @GT NOT IN (N'Nữ','Nam')
		BEGIN 
			PRINT N'Giới Tính Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END  
		IF @Luong < 1000000
		BEGIN 
			PRINT N'Lương Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END  
		IF NOT EXISTS(SELECT * FROM CHI_NHANH WHERE cn_id=@MaCN)
		BEGIN 
			PRINT N'Chi Nhánh '+ @MaCN + N' Không Tồn Tại'
			ROLLBACK TRAN
			RETURN 1
		END 
		DECLARE @MaNV INT = (SELECT MAX(nv_id) FROM NHAN_VIEN) + 1
		INSERT INTO NHAN_VIEN( nv_id ,nv_ten ,nv_dchi ,nv_sdt ,nv_nsinh ,nv_gtinh ,nv_luong ,nv_idcn)
		VALUES  ( @MaNV , @TenNV , @DiaChi , @SDT , @NgaySinh , @GT , @Luong , @MaCN)
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH 
COMMIT TRAN 
RETURN 0
GO 

EXEC AD_ThemNhanVien @TenNV = N'Nguyễn Văn A', -- nvarchar(30)
    @DiaChi = N'Tân Phú, TPHCM', -- nvarchar(100)
    @SDT = '0123455678', -- char(10)
    @NgaySinh = '2000-12-03', -- date
    @GT = N'Nam', -- nvarchar(3)
    @Luong = 10000000.0, -- float
    @MaCN = 'CN0001' -- char(6)
GO 
--DELETE FROM dbo.NHAN_VIEN WHERE nv_id = 11

--Xóa nhân viên (đối với nhân viên đã thực hiện đăng nhà thì không cho phép xóa)
CREATE
--ALTER
PROC AD_XoaNhanVien
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

EXEC AD_XoaNhanVien @MaNV = 11 -- int
GO
--Sửa nhân viên
CREATE
--ALTER
PROC AD_SuaNhanVien
(
	@MaNV int,
	@TenNV nvarchar(30),
	@DiaChi nvarchar(100),
	@SDT char(10),
	@NgaySinh date,
	@GT nvarchar(3),
	@Luong float, 
	@MaCN char(6)
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
		IF @TenNV IS NULL OR @TenNV = ''
		BEGIN 
			PRINT N'Tên Nhân Viên Không Được Trống'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF LEN(@SDT) <> 10
		BEGIN 
			PRINT N'SDT Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF DATEDIFF(YEAR,@NgaySinh,GETDATE()) < 18
		BEGIN 
			PRINT N'Ngày Sinh Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END 
		IF @GT NOT IN (N'Nữ','Nam')
		BEGIN 
			PRINT N'Giới Tính Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END  
		IF @Luong < 1000000
		BEGIN 
			PRINT N'Lương Không Hợp Lệ'
			ROLLBACK TRAN
			RETURN 1
		END  
		IF NOT EXISTS(SELECT * FROM CHI_NHANH WHERE cn_id=@MaCN)
		BEGIN 
			PRINT N'Chi Nhánh '+ @MaCN + N' Không Tồn Tại'
			ROLLBACK TRAN
			RETURN 1
		END 
		UPDATE NHAN_VIEN 
		SET nv_ten = @TenNV,
			nv_dchi = @DiaChi,
			nv_sdt = @SDT,
			nv_nsinh = @NgaySinh,
			nv_gtinh = @GT,
			nv_luong = @Luong,
			nv_idcn = @MaCN
		WHERE nv_id = @MaNV
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH 
COMMIT TRAN 
RETURN 0
GO 

EXEC dbo.AD_SuaNhanVien @MaNV = 11, -- int
    @TenNV = N'Nguyễn Văn A', -- nvarchar(30)
    @DiaChi = N'Tân Phú, TPHCM', -- nvarchar(100)
    @SDT = '0123455678', -- char(10)
    @NgaySinh = '2000-12-03', -- date
    @GT = N'Nam', -- nvarchar(3)
    @Luong = 11000000.0, -- float
    @MaCN = 'CN0001' -- char(6)
GO 





--KH5, KH10, NV1, NV2

--kh5
--Đặt lịch hẹn xem nhà
--Đầu tiên khách sẽ đặt lịch, còn ô nhận xét sẽ tạm để trống, sau khi xem xog, nhân viên có nhiệm vụ gõ vào chỗ nhận xét, làm 2 cái proc riêng, hê hê
create proc KH_DAT_LICH_HEN_XEM_NHA
(
	--khách hàng nhập tên và sđt để truy ra cái idkh vì kh ko biết id của mình là gì, còn muốn làm đơn giản hơn thì cho khách nhập thẳng id
	@TEN nvarchar (30),
	@SĐT char(10),
	@IDNha char(6),
	@NgayXem date
)
as
begin tran
	begin try
		if not exists (select * from NHA where nha_id = @IDNha )
		begin
			print N'Không tồn tại nhà này'
			rollback tran
			return 1
		end
		declare @idkh int = (select kh_id from KHACH_HANG where @TEN = kh_ten and @SĐT = kh_sdt)
		declare @nhanxet nvarchar(50) = N'Chưa xem'
		insert into XEM_NHA
			values(@idkh,@IDNha,@NgayXem,@nhanxet)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go

--sau khi khách hàng xem nhà xog thì nhân viên sẽ cập nhật lại nhận xét 
create proc NV_capnhat_nhanxet_saukhiKHxemnha
(
	@idkh int,
	@IDNha char(6),
	@NgayXem date,
	@NhanXet nvarchar(50)
)
as
begin tran
	begin try
		if not exists (select * from NHA where nha_id = @IDNha )
		begin
			print N'Không tồn tại nhà này'
			rollback tran
			return 1
		end
		if not exists (select * from KHACH_HANG where kh_id=@idkh )
		begin
			print N'Không tồn tại khách hàng này'
			rollback tran
			return 1
		end
		
		update dbo.XEM_NHA
			set x_nxet = @NhanXet
			where x_idnha = @IDNha and x_idkh=@idkh and x_ngxem = @NgayXem
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go
		
--KH10
--Đăng bài bán nhà
--Khách hàng sẽ thêm 1 số thông tin, admin hoặc nhân viên sau khi nhận được thông tin đó thì thêm vài thông tin nữa cho chuẩn, những gì ban đầu kh ko thêm
--thì để tạm là chờ, cái idnha hơi khó ở chỗ là nó kiểu char, t chưa biết cách làm sao cho tự cập nhật được nên sẽ xem như là kh biết trước id nhà, để coi
--sau có nghĩ ra được ko, ko thì để tạm đó, hê hê
create proc KH_DANG_BAI_BAN_NHA
(

@nha_id char(6),
@nha_slphong int,
@nha_ttrang nvarchar(25),
@nha_duong nvarchar(30),
@nha_quan nvarchar(15),
@nha_kvuc nvarchar(15),
@nha_tp nvarchar(15),
@nha_giab float,
@nha_tenloai nvarchar(15),
@nha_idchu int,
@nha_ndang date,
@nha_hethan date

)
as
begin tran
	begin try
		declare @nha_giat float = NULL
		declare @nha_dkban nvarchar(100) = NULL
		declare @nha_idloai char(2) = (select l_id from LOAI_NHA where @nha_tenloai = l_ten)

		 --nhân viên cho giá trị random
		 --khúc này là tính số nhân viên hiện h để lấy hàm random nè, radom từ nhân viên số 1 đến số lớn nhất
		declare @max_idnv int = (select MAX(nv_id) from NHAN_VIEN)
		declare @nha_idnv int = (SELECT FLOOR(RAND()*(@max_idnv-1+1)+1))
		
		--lấy id chi nhánh dựa theo id nhân viên 
		declare @nha_idcn char(6) = (select nv_idcn from NHAN_VIEN where @nha_idnv = nv_id)

		insert into NHA
			values(@nha_id,@nha_slphong,@nha_ttrang,@nha_duong,@nha_quan,@nha_kvuc,@nha_tp,
				   @nha_giat,@nha_giab,@nha_dkban,@nha_idloai,@nha_idchu,@nha_idcn,@nha_idnv,@nha_ndang,@nha_hethan)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go
--sau khi khách thêm nhà thì admin hoặc nhân viên sẽ thêm vào 1 số thông tin nếu có, cái này gọi lên khi có gì đó thui nhé

--KH đăng bài cho thuê nhà
create proc KH_DANG_BAI_THUE_NHA
(

@nha_id char(6),
@nha_slphong int,
@nha_ttrang nvarchar(25),
@nha_duong nvarchar(30),
@nha_quan nvarchar(15),
@nha_kvuc nvarchar(15),
@nha_tp nvarchar(15),
@nha_giat float,
@nha_tenloai nvarchar(15),
@nha_idchu int,
@nha_ndang date,
@nha_hethan date

)
as
begin tran
	begin try
		declare @nha_giab float = NULL
		declare @nha_dkban nvarchar(100) = NULL
		declare @nha_idloai char(2) = (select l_id from LOAI_NHA where @nha_tenloai = l_ten)

		 --nhân viên cho giá trị random
		 --khúc này là tính số nhân viên hiện h để lấy hàm random nè, radom từ nhân viên số 1 đến số lớn nhất
		declare @max_idnv int = (select MAX(nv_id) from NHAN_VIEN)
		declare @nha_idnv int = (SELECT FLOOR(RAND()*(@max_idnv-1+1)+1))
		
		--lấy id chi nhánh dựa theo id nhân viên 
		declare @nha_idcn char(6) = (select nv_idcn from NHAN_VIEN where @nha_idnv = nv_id)

		insert into NHA
			values(@nha_id,@nha_slphong,@nha_ttrang,@nha_duong,@nha_quan,@nha_kvuc,@nha_tp,
				   @nha_giat,@nha_giab,@nha_dkban,@nha_idloai,@nha_idchu,@nha_idcn,@nha_idnv,@nha_ndang,@nha_hethan)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go

--NV1,2
--NV1 tương tự như admin, chỉ cần gọi lại là được
--NV2 Thống kê doanh thu theo hợp đồng đã kí được 
--Thống kê nhà bán theo năm
create proc NV_ThongKe_DoanhThuNhaBan_TheoNam
as
begin tran
	begin try
		select YEAR(hd_ngay) as Năm,SUM(hd_tongtien) as DoanhThu from HOP_DONG where hd_loai = N'Bán'
		group by YEAR(hd_ngay)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_ThongKe_DoanhThuNhaBan_TheoNam
go
--Thống kê nhà bán theo quý trong 1 năm xác định nào đó

create proc NV_ThongKe_DoanhThuNhaBan_TheoQuy
(
	@year int
)
as
begin tran
	begin try
		select DATEPART(QUARTER, hd_ngay) as Quý,SUM(hd_tongtien) as Doanh_Thu from HOP_DONG where hd_loai = N'Bán' and YEAR(hd_ngay) = @year
		group by DATEPART(QUARTER, hd_ngay)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_ThongKe_DoanhThuNhaBan_TheoQuy 2020
go

--Thống kê nhà thêu theo năm
create proc NV_ThongKe_DoanhThuNhaThue_TheoNam
as
begin tran
	begin try
		select YEAR(hd_ngay) as Năm,SUM(hd_tongtien) as DoanhThu from HOP_DONG where hd_loai = N'Thuê'
		group by YEAR(hd_ngay)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_ThongKe_DoanhThuNhaThue_TheoNam
go
--Thống kê nhà thuê theo quý trong 1 năm xác định nào đó

create proc NV_ThongKe_DoanhThuNhaThue_TheoQuy
(
	@year int
)
as
begin tran
	begin try
		select DATEPART(QUARTER, hd_ngay) as Quý,SUM(hd_tongtien) as Doanh_Thu from HOP_DONG where hd_loai = N'Thuê' and YEAR(hd_ngay) = @year
		group by DATEPART(QUARTER, hd_ngay)
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go
--exec NV_ThongKe_DoanhThuNhaThue_TheoQuy 2020

--NV xem nhà
create proc NV_Xem_Nha(@nha_id char(6))
as
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
--exec NV_Xem_Nha BT0001
--tìm kiếm nhân viên với mã nhân viên
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
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go

