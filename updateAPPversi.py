#!/usr/bin/python3
import urllib.request, json, mysql.connector
import os

skrip_dir = os.path.dirname(os.path.abspath(__file__))

json_url = "http://gain-profit.github.io/updater.json"
response = urllib.request.urlopen(json_url);
str_response = response.readall().decode('utf-8')
obj = json.loads(str_response)

cnx = mysql.connector.connect(user='cahya', password='42jo54ri', database='profit',host='192.168.51.2')
cur = cnx.cursor()

replace_app = ("REPLACE INTO app_versi "
               "(kode, path, md5_file, versi_terbaru, URLdownload) "
               "VALUES (%s, %s, %s, %s, %s)")

for row in obj["profit"]:
    url = row["download"]
    file_name = os.path.basename(url)
    path = row["path"]
    target = skrip_dir + path +file_name
    file_exists = os.path.exists(target)
   
    #download latest file
    if file_exists == False :
        urllib.request.urlretrieve(url, target)
        #print("download ...", target)
    '''
    #download report
    file_path,extension = os.path.splitext(target)
    if extension == ".fr3":
        urllib.request.urlretrieve(url, target)
    '''
    # update database
    data_app = (row["nama"],row["path"],row["md5_file"],row["versi"],row["download"])
    #print("Replace --> ", row["nama"])
    cur.execute(replace_app,data_app)
    cnx.commit()

cur.close()
cnx.close()

