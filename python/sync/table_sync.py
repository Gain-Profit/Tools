#!/usr/bin/python3
import mysql.connector
import os
from collections import deque

class Table:
    def __init__(self, con, field, name):
        self.con = con
        self.field = field
        self.name = name
    
    def getQuery(self):
        return 'SELECT ' + self.field + ' FROM ' + self.name + ' WHERE sync = 0'
    
    def getReplace(self):
        isi = []
        for i in self.field.split(', '):
            isi.append('%s')

        return 'REPLACE INTO ' + self.name + ' (' + self.field + ') VALUES (' + ', '.join(isi) + ')'
    
    def updateSync(self):
        return "UPDATE " + self.name + " SET sync = 1 WHERE sync = 0"

def sync(sumber, tujuan):
    cnx = mysql.connector.connect(**sumber.con)
    cux = cnx.cursor()
    
    cux.execute(sumber.getQuery(),)

    d = deque()
    for (data) in cux:
        d.append(data)

    if d:
        cns = mysql.connector.connect(**tujuan.con)
        cus = cns.cursor()

        cus.executemany(tujuan.getReplace(),d)
        cns.commit()

        cus.close()
        cns.close()

        cux.execute(sumber.updateSync(),)
        cnx.commit()
        
    cux.close()
    cnx.close()

