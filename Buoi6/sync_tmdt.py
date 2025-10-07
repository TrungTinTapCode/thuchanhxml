import mysql.connector
from lxml import etree
from datetime import datetime

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="@datacuatrungtin",  # Nếu bạn có password MySQL thì điền vào đây
    database="buoi6xml",
)
cursor = conn.cursor()

def write_log(message):
    with open("sync_log.txt", "a", encoding="utf-8") as log:
        log.write(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {message}\n")

xml_file = "tmdt.xml"
xsd_file = "tmdt.xsd"

xml_doc = etree.parse(xml_file)
xsd_doc = etree.parse(xsd_file)
xmlschema = etree.XMLSchema(xsd_doc)

if not xmlschema.validate(xml_doc):
    print(" XML KHÔNG hợp lệ với XSD!")
    for error in xmlschema.error_log:
        print(f"  - {error.message}")
    exit()
else:
    print(" XML hợp lệ với XSD!\n")

root = xml_doc.getroot()

cursor.execute(
    """
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100)
)
"""
)

cursor.execute(
    """
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    currency VARCHAR(10),
    stock INT,
    category_id VARCHAR(10),
    FOREIGN KEY (category_id) REFERENCES categories(id)
)
"""
)

conn.commit()

categories = root.xpath("//categories/category")
products = root.xpath("//products/product")

for cat in categories:
    cat_id = cat.get("id")
    cat_name = cat.text.strip()

    cursor.execute("SELECT id FROM categories WHERE id = %s", (cat_id,))
    if cursor.fetchone():
        cursor.execute("UPDATE categories SET name=%s WHERE id=%s", (cat_name, cat_id))
        write_log(f"Cập nhật danh mục: {cat_id} - {cat_name}")
    else:
        cursor.execute(
            "INSERT INTO categories (id, name) VALUES (%s, %s)", (cat_id, cat_name)
        )
        write_log(f"Thêm danh mục mới: {cat_id} - {cat_name}")

conn.commit()

changes_added = []
changes_updated = []

for prod in products:
    prod_id = prod.get("id")
    category_ref = prod.get("categoryRef")
    name = prod.findtext("name").strip()
    price = float(prod.findtext("price"))
    currency = prod.find("price").get("currency")
    stock = int(prod.findtext("stock"))

    cursor.execute(
        "SELECT name, price, currency, stock, category_id FROM products WHERE id = %s",
        (prod_id,),
    )
    existing = cursor.fetchone()

    if existing:
        old_name, old_price, old_currency, old_stock, old_cat = existing
        changes = []

        if name != old_name:
            changes.append(f"Tên: '{old_name}' → '{name}'")
        if price != float(old_price):
            changes.append(f"Giá: {old_price} → {price}")
        if currency != old_currency:
            changes.append(f"Tiền tệ: {old_currency} → {currency}")
        if stock != old_stock:
            changes.append(f"Tồn kho: {old_stock} → {stock}")
        if category_ref != old_cat:
            changes.append(f"Danh mục: {old_cat} → {category_ref}")

        if changes:
            cursor.execute(
                """
                UPDATE products
                SET name=%s, price=%s, currency=%s, stock=%s, category_id=%s
                WHERE id=%s
            """,
                (name, price, currency, stock, category_ref, prod_id),
            )
            conn.commit()
            changes_updated.append((prod_id, changes))
            write_log(f"Cập nhật sản phẩm {prod_id}: {', '.join(changes)}")

    else:
        cursor.execute(
            """
            INSERT INTO products (id, name, price, currency, stock, category_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """,
            (prod_id, name, price, currency, stock, category_ref),
        )
        conn.commit()
        changes_added.append(prod_id)
        write_log(f"Thêm sản phẩm mới: {prod_id} - {name}")


cursor.execute("SELECT id FROM products")
existing_ids = [row[0] for row in cursor.fetchall()]
xml_ids = [prod.get("id") for prod in products]

deleted_products = []
for pid in existing_ids:
    if pid not in xml_ids:
        cursor.execute("DELETE FROM products WHERE id = %s", (pid,))
        conn.commit()
        deleted_products.append(pid)
        write_log(f"Đã xóa sản phẩm không còn trong XML: {pid}")

if changes_added:
    print(" Sản phẩm mới được thêm:")
    for pid in changes_added:
        print(f"   - ID: {pid}")

if changes_updated:
    print("\n Sản phẩm được cập nhật:")
    for pid, change_list in changes_updated:
        print(f"   - ID: {pid}")
        for c in change_list:
            print(f"      • {c}")

if deleted_products:
    print("\n Sản phẩm bị xóa do không còn trong XML:")
    for pid in deleted_products:
        print(f"   - ID: {pid}")

if not (changes_added or changes_updated or deleted_products):
    print(" Không có thay đổi nào trong danh sách sản phẩm.")

print("\n Hoàn tất đồng bộ dữ liệu XML → MySQL!")

cursor.close()
conn.close()
