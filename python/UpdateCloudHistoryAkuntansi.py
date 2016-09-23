#!/usr/bin/python3
import mysql.connector
import os
from collections import deque

cns = mysql.connector.connect(user='root', password='server', database='akuntan',host='localhost')
cus = cns.cursor()

cnx = mysql.connector.connect(user='root', password='server', database='profit',host='localhost')
cux = cnx.cursor()

query_history = ("SELECT kd_perusahaan, kd_kiraan, tahun, bulan, saldo_awal, debet, kredit "
              "FROM tb_jurnal_history WHERE sync = 0")
cux.execute(query_history,)
print(cux)

d = deque()
for (data) in cux:
    d.append(data)

# print(d)

cux.close()

replace_query = ("REPLACE INTO jurnal_sejarahs "
                 "(perusahaan_id, kiraan_id, tahun, bulan, saldo_awal, debit, kredit) "
                 "VALUES (%s, %s, %s, %s, %s, %s, %s)")
                
cus.executemany(replace_query,d)
cns.commit()

cus.close()

cbx = cnx.cursor()
update_query = ("UPDATE tb_jurnal_history SET sync = 1 WHERE sync = 0")
                
cbx.execute(update_query,)
cnx.commit()

cnx.close()
cns.close()

