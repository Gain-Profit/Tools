import urllib.request, json, mysql.connector

url = "http://gain-profit.github.io/updater.json"
response = urllib.request.urlopen(url);
str_response = response.readall().decode('utf-8')
obj = json.loads(str_response)

cnx = mysql.connector.connect(user='root', password='server', database='profit')
cur = cnx.cursor()

replace_app = ("REPLACE INTO app_versi "
               "(kode, versi_terbaru, URLdownload) "
               "VALUES (%s, %s, %s)")

#print(obj)
for row in obj["profit"]:
    data_app = (row["nama"],row["versi"],row["download"])
    cur.execute(replace_app,data_app)
    cnx.commit()

cur.close()
cnx.close()
