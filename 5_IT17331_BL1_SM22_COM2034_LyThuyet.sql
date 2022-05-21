-- Các phím tắt cơ bản Azure:
-- Ctrl + /: Dùng comment code
-- F5: Dùng để chạy câu lệnh SQL

-- Sử dụng SQL: 
-- Chạy câu lệnh SQL đang được chọn (Ctrl + E)
-- Chuyển câu lệnh đang chọn thành chữ hoa, chữ thường (Ctrl + Shift + U, Ctrl + Shift + L)
-- Comment và bỏ comment dòng lệnh ( Ctrl + K + C; Ctrl + K + U)

-- Bài 1 Tạo biến bằng lệnh Declare trong SQL SERVER
-- 1.1 Để khai báo biến thì các bạn sử dụng từ khóa Declare với cú pháp như sau:
-- DECLARE @var_name data_type;
-- @var_name là tên của biến, luôn luôn bắt đầu bằng ký tự @
-- data_type là kiểu dữ liệu của biến
-- Ví dụ:
DECLARE @YEAR AS INT
DECLARE @a1 AS INT, @a2 AS VARCHAR

-- 1.2 Gán giá trị cho biến
-- SQL Server để gán giá trị thì bạn sử dụng từ khóa SET và toán tử = với cú pháp sau
-- SET @var_name = value
SET @YEAR = 2022

-- 1.2 Truy xuất giá trị của biến SELECT @<Tên biến> 
SELECT @YEAR
-- 2 Bài: Tính tổng 3 số và tính diện tích hình chữ nhật.
DECLARE @b1 INT, @b2 INT, @b3 INT
SET @b1 = 1
SET @b2 = 1
SET @b3 = 1
SELECT (@b1 + @b2 + @b3)

-- 1.3 Lưu trữ câu truy vấn vào biến
DECLARE @SLTonMax INT
SET @SLTonMax = (SELECT MAX(SoLuongTon) FROM ChiTietSP)
--SELECT @SLTonMax
PRINT N'Số lượng SP tồn kho lớn nhất là: ' + CONVERT(VARCHAR,@SLTonMax)

-- 1.4 Biến bảng
DECLARE @TB_NhanVien TABLE(Id INT,MaNV VARCHAR(50),TenNV NVARCHAR(50))

INSERT INTO @TB_NhanVien
SELECT Id,Ma,Ten FROM NhanVien
WHERE Ten LIKE 'T%'

SELECT * FROM @TB_NhanVien

DECLARE @TB_SinhVien TABLE(Id INT,Ma VARCHAR(50),Ten NVARCHAR(50))
INSERT INTO @TB_SinhVien
VALUES(1,'PH123',N'Tồn')
SELECT * FROM @TB_SinhVien
-- Sửa tên Tồn => FPOLY
UPDATE @TB_SinhVien
SET Ten = 'FPOLY'
WHERE Id = 1
SELECT * FROM @TB_SinhVien

-- 1.7 Begin và End
/* T-SQL tổ chức theo từng khối lệnh
   Một khối lệnh có thể lồng bên trong một khối lệnh khác
   Một khối lệnh bắt đầu bởi BEGIN và kết thúc bởi
   END, bên trong khối lệnh có nhiều lệnh, và các
   lệnh ngăn cách nhau bởi dấu chấm phẩy	
   BEGIN
    { sql_statement | statement_block}
   END
*/
BEGIN
	SELECT Id,SoLuongTon,GiaNhap 
	FROM ChiTietSP
	WHERE SoLuongTon > 900

	IF @@ROWCOUNT =0
	PRINT N'Không có sản phẩm tồn lớn hơn 1000'
	ELSE
	PRINT N'Có sản phẩm thỏa mãn lớn hơn 1000'
END

-- 1.8 Begin và End lồng nhau
BEGIN
	DECLARE @Ten NVARCHAR(50)
	SELECT TOP 1
	@Ten = Ten
	FROM NhanVien
	WHERE Ten = N'Thụ'
	ORDER BY Ten

	IF @@ROWCOUNT <>0
	BEGIN
		PRINT N'Tìm thấy người đầu tiên có tên: ' + @Ten
	END
	ELSE
	BEGIN
		PRINT N'Không tìm thấy người nào có tên như vậy'
	END
END

-- 1.9 CAST ÉP KIỂU DỮ LIỆU
-- Hàm CAST trong SQL Server chuyển đổi một biểu thức từ một kiểu dữ liệu này sang kiểu dữ liệu khác. 
-- Nếu chuyển đổi không thành công, CAST sẽ báo lỗi, ngược lại nó sẽ trả về giá trị chuyển đổi tương ứng.
-- CAST(bieuthuc AS kieudulieu [(do_dai)])
SELECT CAST(1.2 AS INT)--= 1
SELECT CAST(2.3 AS FLOAT)
SELECT CAST(4.6 AS VARCHAR(50))
SELECT CAST('4.9' AS FLOAT)
SELECT CAST('2022-01-15' AS DATE)

-- 2.0 CONVERT 
-- Hàm CONVERT trong SQL Server cho phép bạn có thể chuyển đổi một biểu thức nào đó sang một kiểu dữ liệu 
-- bất kỳ mong muốn nhưng có thể theo một định dạng nào đó (đặc biệt đối với kiểu dữ liệu ngày). 
-- Nếu chuyển đổi không thành công, CONVERT sẽ báo lỗi, ngược lại nó sẽ trả về giá trị chuyển đổi tương ứng.
-- CONVERT(kieudulieu(do_dai), bieuthuc, dinh_dang)
-- dinh_dang (không bắt buộc): là một con số chỉ định việc định dạng cho việc chuyển đổi dữ liệu từ dạng ngày sang dạng chuỗi.
-- Các định dạng trong convert 101,102.........các tham số định dạng https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

SELECT CONVERT(int,14.3)--=14
SELECT CONVERT(float,'10.3')
SELECT CONVERT(datetime,'2022-05-21')
SELECT CONVERT(varchar,'05/21/2022',101)
SELECT CONVERT(date,'2022.05.22',102)
SELECT CONVERT(date,'21/05/2022',103)

-- Ví dụ. Hiển thị ngày tháng năm sinh của nhân viên
SELECT NgaySinh,
	CAST(NgaySinh AS VARCHAR) AS N'Ngày sinh 1',
	CONVERT(VARCHAR,NgaySinh,101) AS '101',
	CONVERT(VARCHAR,NgaySinh,102) AS '102',
	CONVERT(VARCHAR,NgaySinh,103) AS '103'
FROM NhanVien

-- 2.1 Các hàm toán học Các hàm toán học (Math) được dùng để thực hiện các phép toán số học trên các giá trị. 
-- Các hàm toán học này áp dụng cho cả SQL SERVER và MySQL.
-- 1. ABS() Hàm ABS() dùng để lấy giá trị tuyệt đối của một số hoặc biểu thức.
-- Hàm ABS() dùng để lấy giá trị tuyệt đối của một số hoặc biểu thức.
SELECT ABS(-3)
-- 2. CEILING()
-- Hàm CEILING() dùng để lấy giá trị cận trên của một số hoặc biểu thức, tức là lấy giá trị số nguyên nhỏ nhất nhưng lớn hơn số hoặc biểu thức tương ứng.
-- CEILING(num_expr)
SELECT CEILING(3.1)
-- 3. FLOOR()
-- Ngược với CEILING(), hàm FLOOR() dùng để lấy cận dưới của một số hoặc một biểu thức, tức là lấy giá trị số nguyên lớn nhất nhưng nhỏ hơn số hoặc biểu thức tướng ứng.
-- FLOOR(num_expr)
SELECT FLOOR(9.9)
-- 4. POWER()
-- POWER() dùng để tính luỹ thừa của một số hoặc biểu thức.
-- POWER(num_expr,luỹ_thừa)
SELECT POWER(3,2)
-- 5. ROUND()
-- Hàm ROUND() dùng để làm tròn một số hay biểu thức.
-- ROUND(num_expr,độ_chính_xác)
SELECT ROUND(9.123456,2)-- = 9.123500
-- 6. SIGN()
-- Hàm SIGN() dùng để lấy dấu của một số hay biểu thức. Hàm trả về +1 nếu số hoặc biểu thức có giá trị dương (>0),
-- -1 nếu số hoặc biểu thức có giá trị âm (<0) và trả về 0 nếu số hoặc biểu thức có giá trị =0.
SELECT SIGN(-99)
SELECT SIGN(100-50)
-- 7. SQRT()
-- Hàm SQRT() dùng để tính căn bậc hai của một số hoặc biểu thức, giá trị trả về của hàm là số có kiểu float.
-- Nếu số hay biểu thức có giá trị âm (<0) thì hàm SQRT() sẽ trả về NULL đối với MySQL, trả về lỗi đối với SQL SERVER.
-- SQRT(float_expr)
SELECT SQRT(9)
SELECT SQRT(9-5)
-- 8. SQUARE()
-- Hàm này dùng để tính bình phương của một số, giá trị trả về có kiểu float. Ví dụ:
SELECT SQUARE(9)
-- 9. LOG()
-- Dùng để tính logarit cơ số E của một số, trả về kiểu float. Ví dụ:
SELECT LOG(9) AS N'Logarit cơ số E của 9'
-- 10. EXP()
-- Hàm này dùng để tính luỹ thừa cơ số E của một số, giá trị trả về có kiểu float. Ví dụ:
SELECT EXP(2)
-- 11. PI()
-- Hàm này trả về số PI = 3.14159265358979.
SELECT PI()
-- 12. ASIN(), ACOS(), ATAN()
-- Các hàm này dùng để tính góc (theo đơn vị radial) của một giá trị. Lưu ý là giá trị hợp lệ đối với 
-- ASIN() và ACOS() phải nằm trong đoạn [-1,1], nếu không sẽ phát sinh lỗi khi thực thi câu lệnh. Ví dụ:
SELECT ASIN(1) as [ASIN(1)], ACOS(1) as [ACOS(1)], ATAN(1) as [ATAN(1)];

-- 2.2 Các hàm xử lý chuỗi làm việc với kiểu chuỗi
/*
 LEN(string)  Trả về số lượng ký tự trong chuỗi, tính cả ký tự trắng đầu chuỗi
 LTRIM(string) Loại bỏ khoảng trắng bên trái
 RTRIM(string)  Loại bỏ khoảng trắng bên phải
 LEFT(string,length) Cắt chuỗi theo vị trí chỉ định từ trái
 RIGHT(string,legnth) Cắt chuỗi theo vị trí chỉ định từ phải
 TRIM(string) Cắt chuỗi 2 đầu nhưng từ bản SQL 2017 trở lên mới hoạt động
*/
SELECT LEN('SQL SERVER')--= 10
SELECT LTRIM('    SQL SERVER')
SELECT RTRIM('    SQL SERVER     ')
SELECT RTRIM(LTRIM('   SQL SERVER     '))-- Loại bỏ khoảng trắng 2 đầu cách cũ

/*Nếu chuỗi gồm hai hay nhiều thành phần, bạn có thể phân
tách chuỗi thành những thành phần độc lập.
Sử dụng hàm CHARINDEX để định vị những ký tự phân tách.
Sau đó, dùng hàm LEFT, RIGHT, SUBSTRING và LEN để trích ra
những thành phần độc lập*/
DECLARE  @TB_NAMES TABLE(Ten NVARCHAR(MAX))
INSERT INTO @TB_NAMES
VALUES(N'Nguyễn Bá Tồn'),(N'Võ Văn Kiệt')
SELECT Ten,
	LEN(Ten) AS N'Độ Dài chuỗi',
	CHARINDEX(' ',Ten) AS 'CHARINDEX',
	LEFT(Ten,CHARINDEX(' ',Ten) -1) AS N'Họ',
	RIGHT(Ten,LEN(Ten) - CHARINDEX(' ',Ten)) AS N'Tên'
FROM @TB_NAMES
-- Thử tách nốt thành phần tên thành tên đệm và tên. - 10h30

-- 2.3 Charindex Trả về vị trí được tìm thấy của một chuỗi trong chuỗi chỉ định, 
-- ngoài ra có thể kiểm tra từ vị trí mong  muốn
-- CHARINDEX ( string1, string2 ,[  start_location ] ) = 1 số nguyên
SELECT CHARINDEX('POLY','FPT POLYTECHNIC')
SELECT CHARINDEX('POLY','FPT POLYTECHNIC',3)

-- 2.4 Substring Cắt chuỗi bắt đầu từ vị trí và độ dài muốn lấy 
-- SUBSTRING(string,start,length)
SELECT SUBSTRING('FPT POLYTECHNIC',5,LEN('FPT POLYTECHNIC'))
SELECT SUBSTRING('FPT POLYTECHNIC',5,8)

-- 2.5 Replace Hàm thay thế chuỗi theo giá trị cần thay thế và cần thay thế
-- REPLACE(search,find,replace)
SELECT REPLACE('0912-345-678','-','_')

/* 2.6 
REVERSE(string) Đảo ngược chuỗi truyền vào
LOWER(string)	Biến tất cả chuỗi truyền vào thành chữ thường
UPPER(string)	Biến tất cả chuỗi truyền vào thành chữ hoa
SPACE(integer)	Đếm số lượng khoảng trắng trong chuỗi. 
*/
SELECT LOWER('SQL SERVER 2022')
SELECT UPPER('sql server')
SELECT REVERSE('sql')
SELECT N'Nguyễn' + '  ' + N'Dũng'
SELECT N'Nguyễn' + SPACE(10) + N'Dũng'

-- 2.7 Các hàm ngày tháng năm
SELECT GETDATE()
SELECT CONVERT(DATE,GETDATE())
SELECT CONVERT(TIME,GETDATE())

SELECT YEAR(GETDATE()) AS YEAR,
	MONTH(GETDATE()) AS MONTH,
	DAY(GETDATE()) AS DAY

-- DATENAME: truy cập tới các thành phần liên quan ngày tháng
SELECT DATENAME(YEAR,GETDATE()) AS YEAR,
		DATENAME(MONTH,GETDATE()) AS MONTH,
		DATENAME(DAY,GETDATE()) AS DAY,
		DATENAME(WEEK,GETDATE()) AS WEEK,
		DATENAME(DAYOFYEAR,GETDATE()) AS DAYOFYEAR,
		DATENAME(WEEKDAY,GETDATE()) AS WEEKDAY
-- Truyền ngày sinh của bản thân vào 
DECLARE @Ngay_Sinh_Cua_Toi DATE
SET @Ngay_Sinh_Cua_Toi = '1980-07-27'
SELECT DATENAME(YEAR,@Ngay_Sinh_Cua_Toi) AS YEAR,
		DATENAME(MONTH,@Ngay_Sinh_Cua_Toi) AS MONTH,
		DATENAME(DAY,@Ngay_Sinh_Cua_Toi) AS DAY,
		DATENAME(WEEK,@Ngay_Sinh_Cua_Toi) AS WEEK,
		DATENAME(DAYOFYEAR,@Ngay_Sinh_Cua_Toi) AS DAYOFYEAR,
		DATENAME(WEEKDAY,@Ngay_Sinh_Cua_Toi) AS WEEKDAY

-- 2.8 Câu điều kiện IF ELSE trong SQL
/* Lệnh if sẽ kiểm tra một biểu thức có đúng  hay không, nếu đúng thì thực thi nội dung bên trong của IF, nếu sai thì bỏ qua.
IF BIỂU THỨC   
BEGIN
    { statement_block }
END		  */
IF 1=2
BEGIN
	PRINT N'Đúng'
END
ELSE
BEGIN
	PRINT N'SAI'
END

IF 1=1
	PRINT N'Đúng'
ELSE
	PRINT N'SAI'

-- Viết 1 chương trình tính điểm thi Qua môn  
DECLARE @DiemThi_COM2034 FLOAT
SET @DiemThi_COM2034 = 4.9
IF @DiemThi_COM2034 < 5
	PRINT N'Chúc mừng bạn vừa mất 700k'
ElSE
	PRINT N'Chúc mừng bạn vừa không mất 700k'

-- Về nhà làm bài tập: Tính điểm trung bình môn SQL theo các điều kiện sau: XUẤT SẮC, GIỎI, KHÁ, TRUNG BÌNH, HỌC LẠI.

