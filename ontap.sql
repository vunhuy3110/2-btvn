create database on_tap;
use on_tap;

create table KhachHang(
khachhang_id varchar(10) primary key ,
ho_ten varchar(100) not null,
email varchar(100) not null unique,
so_dien_thoai varchar(15) not null ,
dia_chi varchar(200) 
);

create table SanPham(
sanpham_id varchar(10) primary key,
ten_san_pham varchar(150) not null unique,
gia_ban decimal(12,2) not null CHECK (gia_ban > 0),
trang_thai varchar(100) not null DEFAULT 'Đang bán',
so_luong_ton int not null
);

create table DonHang(
donhang_id INT primary key auto_increment,
khachhang_id VARCHAR(10) not null,
sanpham_id VARCHAR(10) not null,
so_luong int not null CHECK (so_luong > 0),
ngay_dat date not null,
ngay_giao date ,
tong_tien decimal(12,2) not null default 0,
foreign key (khachhang_id) references KhachHang(khachhang_id),
foreign key (sanpham_id) references SanPham(sanpham_id)
);

create table ThanhToan(
thanhtoan_id INT primary key auto_increment,
donhang_id int not null,
phuong_thuc_tt VARCHAR(50)not null,
ngay_tt DATE not null,
so_tien_tt DECIMAL(12,2) not null CHECK (so_tien_tt > 0),
foreign key (donhang_id) references DonHang(donhang_id)
);

insert into KhachHang (khachhang_id,ho_ten, email, so_dien_thoai, dia_chi)
values
('KH001', 'Nguyen Van An', 'an.nguyen@example.com', '0911111111', 'Hanoi, Vietnam'),
('KH002', 'Tran Thu Ha', 'ha.tran@example.com', '0922222222', 'Ho Chi Minh, Vietnam'),
('KH003',	'Le Minh Khoa', 'khoa.le@example.com', '0933333333', 'Danang, Vietnam'),
('KH004',	'Pham Quoc Bao',	'bao.pham@example.com', '0944444444', 'Hue, Vietnam'),
('KH005',	'Hoang Minh Chau',	'chau.hoang@example.com', '0955555555', 'Hai Phong, Vietnam'),
('KH006',	'Do Thi Lan',	'lan.do@example.com', '0966666666', 'Hanoi, Vietnam'),
('KH007',	'Bui Duc Long',	'long.bui@example.com', '0977777777', 'Can Tho, Vietnam'),
('KH008',	'Vo Thanh Dat',	'dat.vo@example.com', '0988888888', 'Nha Trang, Vietnam');

insert into SanPham (sanpham_id,ten_san_pham,gia_ban,trang_thai,so_luong_ton)
values
('SP001',	'Cà phê hạt Arabica 250g',	'180',	'Đang bán',	'100'),
('SP002',	'Trà ô long hộp thiếc',	'120',	'Đang bán',	'80'),
('SP003',	'Bánh quy bơ Kobani',	'90',	'Ngừng bán',	'0'),
('SP004',	'Bình giữ nhiệt inox',	'350',	'Đang bán',	'40'),
('SP005',	'Cốc sứ Kobani',	'150',	'Đang bán',	'60'),
('SP006',	'Máy pha cà phê mini',	'800',	'Đang bán',	'15'),
('SP007',	'Túi vải canvas ',	'120',	'Đang bán',	'70'),
('SP008',	'Sổ tay bìa da', '200',	'Ngừng bán',	'5');

insert into DonHang(donhang_id,	khachhang_id,	sanpham_id,	so_luong,	ngay_dat,	ngay_giao,	tong_tien)
values
('1','KH001',	'SP001',	'2',	'2026-9-1',	'2026-9-3', 	'360'),
('2',	'KH002', 	'SP002',	'1', 	'2026-9-2',	'2026-9-4',	'120'),
('3',	'KH003',	'SP003',	'3',	'2026-9-3',	'2026-9-6',	'270'),
('4',	'KH004',	'SP004',	'1',	'2026-9-4',	'2026-9-7','350'),
('5',	'KH005',	'SP005',	'2','2026-9-5',	'2026-9-8',	'300'),
('6',	'KH006',	'SP006',	'1',	'2026-9-6',	'2026-9-10',	'800'),
('7',	'KH007',	'SP007',	'2',	'2026-9-7',	'2026-9-9',	'240'),
('8',	'KH008',	'SP008',	'1',	'2026-9-8',	'2026-9-11',	'200'),
('9',   'KH001',	'SP004',	'2',	'2026-9-10',	'2026-9-12',	'700'),
('10',	'KH006',	'SP005',	'1',	'2026-9-12',	'2026-9-14',	'150');

insert into ThanhToan (thanhtoan_id,	donhang_id,	phuong_thuc_tt,	ngay_tt,	so_tien_tt)
values
('1',	'1',	'Credit Card',	'2026-9-1',	'360'),
('2',	'2',	'Cash',	'2026-9-2',	'120'),
('3',	'3',	'Bank Transfer',	'2026-9-3',	'270'),
('4',	'4',	'E-Wallet',	'2026-9-4',	'350'),
('5',	'5',	'Credit Card',	'2026-9-5',	'300'),
('6',	'6',	'Bank Transfer',	'2026-9-6',	'800'),
('7',	'7',	'Cash',	'2026-9-7',	'240'),
('8',	'8',	'E-Wallet',	'2026-9-8',	'200'),
('9',	'9',	'Bank Transfer',	'2026-9-10',	'700'),
('10',	'10',	'Cash',	'2026-9-12',	'150');

-- Cập nhật dữ liệu: 
-- Viết câu lệnh UPDATE để cập nhật tong_tien trong bảng DonHang theo công thức: 
-- tong_tien = gia_ban * so_luong + 20.0 (phí đóng gói).
-- •	Chỉ cập nhật cho các đơn hàng có sản phẩm ở trạng thái "Đang bán".
-- •	Chỉ cập nhật khi ngày đặt (ngay_dat) đã qua (ví dụ: ngay_dat < CURDATE()).
update DonHang as d
join SanPham  as s on d.sanpham_id = s.sanpham_id
set d.tong_tien = s.gia_ban * d.so_luong + 20.0
where s.trang_thai='Đang bán'and d.ngay_dat < curdate();

SET SQL_SAFE_UPDATES = 0;

-- 4.	Xóa dữ liệu: Viết câu lệnh DELETE để xóa các thanh toán trong bảng ThanhToan nếu:
-- Phương thức thanh toán (phuong_thuc_tt) là "Cash",
-- Và số tiền thanh toán (so_tien_tt) nhỏ hơn 150.0.
delete from ThanhToan
where phuong_thuc_tt = "Cash" and so_tien_tt < 150.0;

-- 1.	Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, 
-- số điện thoại và địa chỉ, sắp xếp theo họ tên tăng dần.
SELECT khachhang_id, ho_ten, email, so_dien_thoai, dia_chi
FROM KhachHang
ORDER BY ho_ten ASC;
-- 2.	Lấy thông tin các sản phẩm gồm mã sản phẩm, tên sản phẩm, 
-- giá bán và số lượng tồn, sắp xếp theo giá bán giảm dần.
select sanpham_id,ten_san_pham,gia_ban,so_luong_ton
from SanPham
order by gia_ban DESC;

-- 3.	Lấy thông tin khách hàng và sản phẩm đã đặt, gồm mã khách hàng, 
-- họ tên khách hàng, mã sản phẩm, ngày đặt và ngày giao.
SELECT k.khachhang_id,k.ho_ten,d.sanpham_id,d.ngay_dat,d.ngay_giao
from KhachHang as k
join DonHang as d 
  on k.khachhang_id = d.khachhang_id;
  
-- 4.	Lấy danh sách khách hàng và số tiền đã thanh toán,gồm mã khách hàng, 
-- họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.
select k.khachhang_id,k.ho_ten, t.phuong_thuc_tt,	t.so_tien_tt
from KhachHang as k
join DonHang as d
 on k.khachhang_id = d.khachhang_id
join ThanhToan as t
 on d.donhang_id = t.donhang_id
order by t.so_tien_tt desc;

-- 5.	Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng KhachHang được sắp xếp theo họ tên.
select ho_ten, email, so_dien_thoai, dia_chi
from KhachHang
order by ho_ten asc
limit 3 offset 1;

-- 6.	Lấy danh sách khách hàng đã đặt ít nhất 2 đơn hàng và có tổng số tiền thanh toán trên 500.0, 
-- gồm mã khách hàng, họ tên khách hàng và số lượng đơn hàng đã đặt.
select k.khachhang_id, k.ho_ten, count(d.donhang_id) as so_luong_don_hang
from KhachHang as k
join DonHang as d
	on k.khachhang_id = d.khachhang_id
join ThanhToan as t
	on d.donhang_id = t.donhang_id
group by k.khachhang_id, k.ho_ten
having count( d.donhang_id) >= 2 and sum(t.so_tien_tt) >500.0;


-- 7.	Lấy danh sách các sản phẩm có tổng số tiền thanh toán dưới 1000.0 và 
-- có ít nhất 2 khách hàng khác nhau đã đặt, gồm mã sản phẩm, tên sản phẩm, giá bán và tổng số tiền thanh toán.
select s.sanpham_id, s.ten_san_pham, s.gia_ban, sum(t.so_tien_tt) as tong_tien_thanh_toan
from SanPham as s
join DonHang as d
 on s.sanpham_id = d.sanpham_id
join ThanhToan as t
 on d.donhang_id = t.donhang_id
group by s.sanpham_id, s.ten_san_pham, s.gia_ban
having sum(t.so_tien_tt) <1000.0
 and COUNT(DISTINCT d.khachhang_id) >= 2;
 
-- 8.	Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 500.0,  
-- gồm mã khách hàng, họ tên khách hàng và tổng số tiền thanh toán.
select k.khachhang_id, k.ho_ten, sum(t.so_tien_tt) as tong_tien_thanh_toan
from KhachHang as k
join DonHang as d
on k.khachhang_id = d.khachhang_id
join ThanhToan as t
on d.donhang_id = t.donhang_id
group by k.khachhang_id, k.ho_ten
having sum(so_tien_tt) > 500.0;

-- 9.	Lấy danh sách khách hàng (Mã KH, Họ tên, Email, SĐT) có họ tên chứa chữ "Minh" 
-- hoặc địa chỉ (dia_chi) ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.
select khachhang_id, ho_ten,email, so_dien_thoai
from KhachHang
where ho_ten like '%Minh%'
 or dia_chi like' %Hanoi%'
order by ho_ten asc;

-- 10.	Lấy danh sách tất cả các sản phẩm (Mã sản phẩm, Tên sản phẩm, Giá bán), 
-- sắp xếp theo giá bán giảm dần. Hiển thị 3 sản phẩm tiếp theo sau 2 sản phẩm đầu tiên 
-- (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 2 sản phẩm).
select sanpham_id, ten_san_pham, gia_ban
from SanPham
order by gia_ban desc
limit 3 offset 2;

-- PHẦN 3: Tạo View
-- 1.	Tạo một view lấy thông tin các sản phẩm và khách hàng đã đặt hàng, 
-- với điều kiện ngày đặt nhỏ hơn ngày 2026-09-06. 
-- Hiển thị: Mã sản phẩm, Tên sản phẩm, Mã khách hàng, Họ tên khách hàng.
create view thong_tin as
select s.sanpham_id, s.ten_san_pham, k.khachhang_id, k.ho_ten
from DonHang as d
join SanPham 
join KhachHang as k
on d.khachhang_id = k.khachhang_id
-- 2. Tạo một view lấy thông tin khách hàng và đơn hàng đã đặt, 
-- với điều kiện giá bán lớn hơn 200.0. 
-- Hiển thị: Mã khách hàng, Họ tên khách hàng, Mã sản phẩm, Giá bán.-- 


-- PHẦN 4: Tạo Trigger
-- 1.	Tạo trigger check_insert_donhang để kiểm tra dữ liệu mỗi khi chèn vào bảng DonHang. Nếu ngày giao diễn ra trước ngày đặt thì báo lỗi với nội dung "Ngày giao không thể trước ngày đặt hàng được !" và hủy thao tác chèn dữ liệu.
-- 2.	Tạo trigger update_sanpham_status_on_order để tự động cập nhật trạng thái sản phẩm thành "Ngừng bán" khi sản phẩm đó được đặt quá 30 lần trong cùng một ngày (khi có bản ghi được INSERT vào bảng DonHang làm vượt hạn mức).
-- PHẦN 5: Tạo Stored Procedure
-- 1.	Viết stored procedure add_khachhang để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
-- 2.	Viết stored procedure add_thanhtoan để thêm một thanh toán mới cho một đơn hàng. Procedure nhận các tham số đầu vào:
-- ￮	p_donhang_id: Mã đơn hàng.
-- ￮	p_phuong_thuc_tt: Phương thức thanh toán.
-- ￮	p_so_tien_tt: Số tiền thanh toán.
-- ￮	p_ngay_tt: Ngày thanh toán.
