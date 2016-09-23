#!/usr/bin/python3
import mysql.connector
import os
from collections import deque

cns = mysql.connector.connect(user='root', password='server', database='profit-web',host='localhost')
cus = cns.cursor()

cus.execute("SELECT updated FROM products ORDER BY updated DESC LIMIT 1")
for (data) in cus:
    last_sync = data[0]

print("last_sync : ",last_sync)

cnx = mysql.connector.connect(user='root', password='server', database='profit',host='localhost')
cur = cnx.cursor()

last_query = "SELECT * FROM vw_products WHERE updated > %s"
cur.execute(last_query,(last_sync,))
print(cur)

d = deque()
for (data) in cur:
    d.append(data)

print(d)

cur.close()
cnx.close()

replace_query = ("REPLACE INTO products "
                 "(pid, barcode, description, unit, price, updated) "
                 "VALUES (%s, %s, %s, %s, %s, %s)")
                
cus.executemany(replace_query,d)
cns.commit()

cus.close()
cns.close()

