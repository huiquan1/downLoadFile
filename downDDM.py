import requests
import json
import os

sessionid = ";jsessionid=C37B5BAB29ED5882C8F6E32C6DB1670B"
floderpath = "E:\\ddm\\"
if not os.path.exists(floderpath):
	os.makedirs(floderpath)

file_object = open('E:\\data.txt')
try:
	print('start download')
	for line in file_object:
		caseId = line.strip('\n')
		url = 'http://192.168.35.85:8001/shidaits/rest/cds/case/' + caseId + '/phase/%E6%96%B0%E7%97%85%E4%BE%8B%E9%98%B6%E6%AE%B5/document' + sessionid
		text = requests.get(url).text
		jsonStr = json.loads(text)
		if 'DDM' in jsonStr['documents']:
			for ddm in jsonStr['documents']['DDM']:
				filename = ddm['filename']
				fileUrl = ddm['fileUrl'] + sessionid
				r = requests.get(fileUrl)
				with open(floderpath + filename, "wb") as code:
					code.write(r.content)
			print('complete download ' + caseId)
		else:
			print(caseId + ' ddm not exist')
finally:
	file_object.close( )
	print ('all download')
