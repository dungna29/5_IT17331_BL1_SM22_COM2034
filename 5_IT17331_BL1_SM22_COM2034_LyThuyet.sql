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
