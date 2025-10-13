<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Quản lý bàn ăn</title>
        <style>
          body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f8fafc;
            color: #333;
            margin: 40px;
          }

          h1 {
            text-align: center;
            color: #2d5be3;
            margin-bottom: 40px;
            letter-spacing: 0.5px;
          }

          h2 {
            color: #1a4ba1;
            padding-left: 10px;
            width: 80%;
            margin: 40px auto 10px auto;
          }

          table {
            border-collapse: collapse;
            width: 80%;
            margin: 10px auto 30px auto;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background: white;
            border-radius: 10px;
            overflow: hidden;
          }

          th {
            background: #2d5be3;
            color: white;
            padding: 10px;
            text-align: center;
            font-weight: 600;
          }

          td {
            border-top: 1px solid #eee;
            padding: 8px 12px;
            text-align: center;
          }

          p {
            width: 80%;
            margin: 0 auto 20px auto;
            font-size: 16px;
          }

          strong {
            color: #2d5be3;
          }

          .footer {
            text-align: center;
            font-size: 14px;
            color: #777;
            margin-top: 50px;
          }
        </style>
      </head>

      <body>
        <h1>BÀI 3 – QUẢN LÝ BÀN ĂN</h1>

        <!-- 1 -->
        <h2> Danh sách tất cả các bàn</h2>
        <table>
          <tr><th>STT</th><th>Số bàn</th><th>Tên bàn</th></tr>
          <xsl:for-each select="QUANLY/BANS/BAN">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="SOBAN"/></td>
              <td><xsl:value-of select="TENBAN"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 2 -->
        <h2> Danh sách nhân viên</h2>
        <table>
          <tr><th>STT</th><th>Mã NV</th><th>Tên NV</th><th>SĐT</th><th>Địa chỉ</th></tr>
          <xsl:for-each select="QUANLY/NHANVIENS/NHANVIEN">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="MANV"/></td>
              <td><xsl:value-of select="TENV"/></td>
              <td><xsl:value-of select="SDT"/></td>
              <td><xsl:value-of select="DIACHI"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 3 -->
        <h2> Danh sách món ăn</h2>
        <table>
          <tr><th>STT</th><th>Mã món</th><th>Tên món</th><th>Giá</th></tr>
          <xsl:for-each select="QUANLY/MONS/MON">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="MAMON"/></td>
              <td><xsl:value-of select="TENMON"/></td>
              <td><xsl:value-of select="GIA"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 4 -->
        <h2> Thông tin nhân viên NV02</h2>
        <table>
          <tr><th>Mã NV</th><th>Tên NV</th><th>SĐT</th><th>Địa chỉ</th><th>Giới tính</th></tr>
          <xsl:for-each select="QUANLY/NHANVIENS/NHANVIEN[MANV='NV02']">
            <tr>
              <td><xsl:value-of select="MANV"/></td>
              <td><xsl:value-of select="TENV"/></td>
              <td><xsl:value-of select="SDT"/></td>
              <td><xsl:value-of select="DIACHI"/></td>
              <td><xsl:value-of select="GIOITINH"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 5 -->
        <h2> Món ăn có giá &gt; 50.000</h2>
        <table>
          <tr><th>STT</th><th>Tên món</th><th>Giá</th></tr>
          <xsl:for-each select="QUANLY/MONS/MON[GIA &gt; 50000]">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="TENMON"/></td>
              <td><xsl:value-of select="GIA"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 6 -->
        <h2> Thông tin hóa đơn HD03</h2>
        <table>
          <tr><th>Tên NV</th><th>Số bàn</th><th>Ngày lập</th><th>Tổng tiền</th></tr>
          <xsl:for-each select="QUANLY/HOADONS/HOADON[SOHD='HD03']">
            <tr>
              <td><xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV"/></td>
              <td><xsl:value-of select="SOBAN"/></td>
              <td><xsl:value-of select="NGAYLAP"/></td>
              <td><xsl:value-of select="TONGTIEN"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 7 -->
        <h2> Các món ăn trong hóa đơn HD02</h2>
        <table>
          <tr><th>STT</th><th>Tên món</th></tr>
          <xsl:for-each select="QUANLY/HOADONS/HOADON[SOHD='HD02']/CTHDS/CTHD">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 8 -->
        <h2> Tên nhân viên lập hóa đơn HD02</h2>
        <table>
          <tr><th>Tên nhân viên</th></tr>
          <tr>
            <td>
              <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=/QUANLY/HOADONS/HOADON[SOHD='HD02']/MANV]/TENV"/>
            </td>
          </tr>
        </table>

        <!-- 9 -->
        <h2> Tổng số bàn</h2>
        <p><strong><xsl:value-of select="count(QUANLY/BANS/BAN)"/></strong> bàn hiện có.</p>

        <!-- 10 -->
        <h2> Số hóa đơn lập bởi NV01</h2>
        <p><strong><xsl:value-of select="count(QUANLY/HOADONS/HOADON[MANV='NV01'])"/></strong> hóa đơn được lập bởi NV01.</p>

        <!-- 11 -->
        <h2> Các món từng bán cho bàn số 2</h2>
        <table>
          <tr><th>STT</th><th>Tên món</th></tr>
          <xsl:for-each select="QUANLY/HOADONS/HOADON[SOBAN='2']/CTHDS/CTHD">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 12 -->
        <h2> Nhân viên từng lập hóa đơn cho bàn số 3</h2>
        <table>
          <tr><th>STT</th><th>Tên NV</th></tr>
          <xsl:for-each select="QUANLY/HOADONS/HOADON[SOBAN='3']">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <!-- 13 -->
        <h2> Món ăn được gọi nhiều hơn 1 lần</h2>
        <table>
          <tr><th>Tên món</th><th>Tổng số lần gọi</th></tr>
          <xsl:for-each select="QUANLY/MONS/MON">
            <xsl:variable name="monID" select="MAMON"/>
            <xsl:variable name="tong" select="count(/QUANLY/HOADONS/HOADON/CTHDS/CTHD[MAMON=$monID])"/>
            <xsl:if test="$tong &gt; 1">
              <tr>
                <td><xsl:value-of select="TENMON"/></td>
                <td><xsl:value-of select="$tong"/></td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>

        <!-- 14 -->
        <h2> Chi tiết hóa đơn HD04</h2>
        <table>
          <tr><th>Mã món</th><th>Tên món</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr>
          <xsl:for-each select="QUANLY/HOADONS/HOADON[SOHD='HD04']/CTHDS/CTHD">
            <xsl:variable name="mon" select="/QUANLY/MONS/MON[MAMON=current()/MAMON]"/>
            <xsl:variable name="gia" select="$mon/GIA"/>
            <xsl:variable name="sl" select="SOLUONG"/>
            <tr>
              <td><xsl:value-of select="$mon/MAMON"/></td>
              <td><xsl:value-of select="$mon/TENMON"/></td>
              <td><xsl:value-of select="$gia"/></td>
              <td><xsl:value-of select="$sl"/></td>
              <td><xsl:value-of select="$gia * $sl"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <div class="footer">
          © 2025 - Buổi 7 XML/XSLT - Bài 3: Quản lý bàn ăn -KTPM2211017
        </div>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
