#!/usr/bin/python3
import urllib.request, json, mysql.connector
import os
from datetime import datetime,date
import collections

class DatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.strftime('%Y-%m-%d %H:%M:%S')
        elif isinstance(obj, date):
            return obj.strftime('%Y-%m-%d')
        return json.JSONEncoder.default(self, obj)

def dictData(data):
    d = collections.OrderedDict()
    d['pid'] = data[0]
    d['barcode'] = data[1]
    d['description'] = data[2]
    d['unit'] = data[3]
    d['price'] = data[4]
    d['updated'] = data[5]
    return d

def postData(data):
    json_data = json.dumps(dictData(data),cls=DatetimeEncoder)
    print('json data',json_data)
    jsondataasbytes = json_data.encode('utf-8')   # needs to be bytes    
    print('json data bytes',json_data)

    post_url = "http://dutaswalayan.com/products"
    req = urllib.request.Request(post_url)
    req.add_header('Content-Type','application/json')
    req.add_header('Content-Length', len(jsondataasbytes))
    response = urllib.request.urlopen(req,jsondataasbytes)
    print(response)
    
last_url = "http://dutaswalayan.com/products/last"
response = urllib.request.urlopen(last_url);
last_response = response.readall().decode('utf-8')
last_obj = json.loads(last_response)

last_sync = last_obj[0]["updated"]
print("last_sync : ",last_sync)

cnx = mysql.connector.connect(user='root', password='server', database='profit',host='localhost')
cur = cnx.cursor()

last_query = "SELECT * FROM vw_products WHERE updated > %s"
cur.execute(last_query,(last_sync,))
print(cur)

for (data) in cur:
    postData(data)

cur.close()
cnx.close()

