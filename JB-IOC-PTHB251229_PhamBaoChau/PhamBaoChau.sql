--1.Tạo bảng
create table Customer(
    customer_id varchar(5) primary key not null,
	customer_full_name varchar(100) not null,
	customer_email varchar(100) not null unique,
	customer_phone varchar(15) not null,
	customer_address varchar(255) not null
);
create type room_status_type as enum('Available', 'Booked');
create table Room(
    room_id varchar(5) primary key not null,
	room_type varchar(50) not null,
	room_price decimal(10, 2) not null,
	room_status room_status_type not null,
	room_area decimal(10, 2)
);

create table Booking(
    booking_id serial primary key not null,
	customer_id varchar(5) not null references Customer(customer_id),
	room_id varchar(5) not null references Room(room_id),
	check_in_date date not null,
	check_out_date date not null,
	total_amount decimal(10, 2)
);

create table Payment(
    payment_id serial primary key not null,
	booking_id int not null references Booking(booking_id),
	payment_method varchar(50) not null,
	payment_date date not null,
	payment_amount decimal(10, 2) not null
);

--2.Chèn dữ liệu (8 điểm) Thêm dữ liệu vào 4 bảng đã tạo:
insert into Customer values
('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', 0912345678, 'Hanoi, Vietnam'),
('C002', 'Tran Thi Mai', 'mai.tran@example.com', 0923456789, 'Ho Chi Minh, Vietnam'),
('C003', 'Le Minh Hoang', 'hoang.le@example.com', 0934567890, 'Danang , Vietnam'),
('C004', 'Pham Hoang Nam', 'nam.pham@example.com', 0945678901, 'Hue, Vietnam'),
('C005', 'Vu Minh Thu', 'thu.vu@example.com', 0956789012, 'Hai Phong, Vietnam');

insert into Room values
('R001', 'Single', 100.0, 'Available', 25),
('R002', 'Double', 150.0, 'Booked', 40),
('R003', 'Suite', 250.0, 'Available', 60),
('R004', 'Single', 120.0, 'Booked', 30),
('R005', 'Double', 160.0, 'Available', 35);

insert into Booking values
(1, 'C001', 'R001', '2025-03-01', '2025-03-05', 400.0),
(2, 'C002', 'R002', '2025-03-02', '2025-03-06', 600.0),
(3, 'C003', 'R003', '2025-03-03', '2025-03-07', 1000.0),
(4, 'C004', 'R004', '2025-03-04', '2025-03-08', 480.0),
(5, 'C005', 'R005', '2025-03-05', '2025-03-09', 800.0);

insert into Payment values
(1, 1, 'Cash', '2025-03-05', 400.0),
(2, 2, 'Credit Card', '2025-03-06', 600.0),
(3, 3, 'Bank Transfer', '2025-03-07', 1000.0),
(4, 4, 'Cash', '2025-03-08', 480.0),
(5, 5, 'Credit Card', '2025-03-09', 800.0);

--3.Cập nhật dữ liệu (6 điểm) 
update Booking set total_amount = room_price * (check_out_date - check_in_date)

--4.Xóa dữ liệu (6 điểm)
delete from Payment where payment_method = 'Cash' and payment_amount < 500;

--5.(3 điểm) Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, số điện thoại và địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.
select customer_id, customer_full_name, customer_email, customer_phone, customer_address from Customer
order by customer_full_name asc;

--6. (3 điểm) Lấy thông tin các phòng khách sạn gồm mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
select room_id, room_type, room_price, room_area from Room 
order by room_price desc;

--7. (3 điểm) Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date 
from Booking b
join Customer c on b.customer_id = c.customer_id;

--8. (3 điểm) Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.
select c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
from Booking b
join Customer c on b.customer_id = c.customer_id
join Payment p on b.booking_id = p.booking_id
order by p.payment_amount desc;

--9. (3 điểm) Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng.
select * from Customer 
order by customer_full_name asc
limit 3 offset 1;

--10. (5 điểm) Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000, gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
select c.customer_id, c.customer_full_name, count(*) as so_luong_phong
from Booking b
join Customer c on b.customer_id = c.customer_id
join Payment p on b.booking_id = p.booking_id
group by c.customer_id, c.customer_full_name
having count(*) >= 2 and sum(p.payment_amount) > 1000;

--11. (5 điểm) Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán.
select r.room_id, r.room_type, r.room_price, sum(p.payment_amount) as t
from Booking b
join Room r on b.room_id = r.room_id
join Payment p on b.booking_id = p.booking_id
group by r.room_id, r.room_type, r.room_price
having  sum(p.payment_amount) < 1000 and count(*) >= 3;

--12. (5 điểm) Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán.
select c.customer_id, c.customer_full_name, b.room_id, sum(p.payment_amount) as t
from Booking b
join Customer c on b.customer_id = c.customer_id
join Payment p on b.booking_id = p.booking_id
group by c.customer_id, c.customer_full_name, b.room_id
having sum(p.payment_amount) > 1000;

--13. (6 điểm) Lấy danh sách các khách hàng Mmã KH, Họ tên, Email, SĐT) có họ tên chứa chữ "Minh" hoặc địa chỉ (address) ở "Hanoi". Sắp xếp kết quả theo họ tên tăng dần.
select customer_id, customer_full_name, customer_email, customer_phone
from Customer
where customer_full_name ilike '%Minh%' or customer_address = 'Hanoi'
order by customer_full_name asc;

--14. (4 điểm)  Lấy danh sách tất cả các phòng (Mã phòng, Loại phòng, Giá), sắp xếp theo giá phòng giảm dần. Hiển thị 5 phòng tiếp theo sau 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
select room_id, room_type, room_price 
from Room 
order by room_price desc
limit 5 offset 5;

--15. (5 điểm) Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-10. Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
create view v_room_customer_0310 as 
select r.room_id, r.room_type, c.customer_id, c.customer_full_name
from Booking b
join Customer c on b.customer_id = c.customer_id
join Room r on b.room_id = r.room_id
where b.check_in_date < '2025-03-10';

--16. (5 điểm) Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m². Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng
create view v_customer_room_30 as
select c.customer_id, c.customer_full_name, r.room_id, r.room_area
from Booking b
join Customer c on b.customer_id = c.customer_id
join Room r on b.room_id = r.room_id
where r.room_area > 30;

--17. (5 điểm) Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.
create or replace function f_check_insert_booking()
returns trigger as $$
begin
    if new.check_in_date > new.check_out_date then
	    raise exception 'Ngày đặt phòng không thể sau ngày trả phòng được !';
	end if;
	return new;
end; $$ language plpgsql;

create or replace trigger tg_check_insert_booking
before insert on Booking
for each row
execute function f_check_insert_booking();

--18. (5 điểm) Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
create or replace function f_update_room_status_on_booking()
returns trigger as $$
begin
    update Room set room_status = 'Booked' where room_id = new.room_id;
	return new;
end; $$ language plpgsql;

create or replace trigger tg_check_insert_booking
after insert on Booking
for each row
execute function f_update_room_status_on_booking();

--19. (5 điểm) Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
create or replace procedure add_customer(
    p_customer_id varchar,
	p_customer_full_name varchar,
	p_customer_email varchar,
	p_customer_phone varchar,
	p_customer_address varchar
)
language plpgsql
as $$
begin
    insert into Customer values(
        p_customer_id ,
	    p_customer_full_name ,
	    p_customer_email ,
	    p_customer_phone ,
	    p_customer_address 
	);
end;
$$;

/*20. (5 điểm) Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
Procedure này nhận các tham số đầu vào:
- p_booking_id: Mã đặt phòng (booking_id).
- p_payment_method: Phương thức thanh toán (payment_method).
- p_payment_amount: Số tiền thanh toán (payment_amount).
- p_payment_date: Ngày thanh toán (payment_date).
*/

create or replace procedure add_payment(
     p_booking_id int,
	 p_payment_method varchar,
	 p_payment_amount decimal,
	 p_payment_date date
)
language plpgsql
as $$
begin
    insert into Payment(booking_id, payment_method, payment_amount, payment_date) values(
        p_booking_id ,
	    p_payment_method ,
	    p_payment_amount ,
	    p_payment_date
	);
end;
$$;

