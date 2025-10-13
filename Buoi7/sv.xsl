<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
    <html>
    <head>
        <title>Danh sách sinh viên</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 40px;
            background: #f9fbfd;
            color: #333;
        }
        h1 {
            text-align: center;
            color: #2d5be3;
            margin-bottom: 40px;
        }
        h2 {
			color: #1a4ba1;
			padding-left: 10px;
			margin-top: 40px;			
			margin-bottom: 10px;
			width: 80%;
			margin-right: auto;
			margin-left: auto;
}

        table {
            border-collapse: collapse;
            width: 80%;
            margin: 10px auto 40px auto;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background: #fff;
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
        .footer {
            text-align: center;
            font-size: 14px;
            color: #888;
            margin-top: 60px;
        }
    </style>
    </head>

    <body>
        <h1>BÀI 1 - DANH SÁCH SINH VIÊN</h1>

        <!-- Câu 1 -->
        <h2> Liệt kê tất cả sinh viên (Mã, Họ tên)</h2>
        <table>
			<tr><th>Mã SV</th><th>Họ tên</th></tr>
			<xsl:for-each select="school/student">
            <tr>
				<td><xsl:value-of select="id"/></td>
				<td><xsl:value-of select="name"/></td>
            </tr>
        </xsl:for-each>
        </table>

        <!-- Câu 2 -->
        <h2> Danh sách sinh viên (Mã, Tên, Điểm) – Sắp xếp giảm dần theo điểm</h2>
        <table>
			<tr><th>Mã SV</th><th>Họ tên</th><th>Điểm</th></tr>
			<xsl:for-each select="school/student">
            <xsl:sort select="grade" data-type="number" order="descending"/>
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="grade"/></td>
            </tr>
            </xsl:for-each>
        </table>

        <!-- Câu 3 -->
        <h2> Sinh viên sinh tháng gần nhau (STT, Họ tên, Ngày sinh)</h2>
        <table>
            <tr><th>STT</th><th>Họ tên</th><th>Ngày sinh</th></tr>
            <xsl:for-each select="school/student">
            <xsl:sort select="substring(date,6,2)" data-type="number"/>
            <tr>
                <td><xsl:value-of select="position()"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="date"/></td>
            </tr>
            </xsl:for-each>
        </table>

        <!-- Câu 4 -->
        <h2> Danh sách các khóa học có sinh viên học (sắp xếp theo tên khóa)</h2>
        <table>
            <tr><th>Mã khóa</th><th>Tên khóa học</th></tr>
            <xsl:for-each select="school/course">
            <xsl:sort select="name"/>
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
            </tr>
            </xsl:for-each>
        </table>

        <!-- Câu 5 -->
        <h2> Sinh viên đăng ký khóa học "Hóa học 201"</h2>
        <table>
            <tr><th>Mã SV</th><th>Họ tên</th></tr>
            <xsl:for-each select="school/enrollment[courseRef = /school/course[name='Hóa học 201']/id]">
            <tr>
                <td><xsl:value-of select="studentRef"/></td>
                <td><xsl:value-of select="/school/student[id=current()/studentRef]/name"/></td>
            </tr>
            </xsl:for-each>
        </table>

        <!-- Câu 6 -->
        <h2> Sinh viên sinh năm 1997</h2>
        <table>
            <tr><th>Mã SV</th><th>Họ tên</th><th>Ngày sinh</th></tr>
            <xsl:for-each select="school/student[substring(date,1,4)='1997']">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="date"/></td>
            </tr>
            </xsl:for-each>
        </table>

        <!-- Câu 7 -->
        <h2> Danh sách sinh viên họ “Trần”</h2>
        <table>
            <tr><th>Mã SV</th><th>Họ tên</th></tr>
            <xsl:for-each select="school/student[starts-with(name, 'Trần')]">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
            </tr>
            </xsl:for-each>
        </table>

        <div class="footer">
            © 2025 - Buổi 7 XML/XSLT - Bài 1: Hiển thị danh sách sinh viên -KTPM2211017
        </div>
    </body>
    </html>
</xsl:template>
</xsl:stylesheet>
