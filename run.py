import requests

file_object = open('data.txt')
try:
    for line in file_object:
        caseId=line.strip('\n')
        print "downloading:"+caseId
        url = 'http://192.168.35.85:8001/shidaits/rest/cds/case/document/download;jsessionid=5A71875670EEBE36C7B4D6A8B22E6476?caseid=' + caseId
        r = requests.get(url)
        with open('target/' + caseId + '.zip', "wb") as code:
             code.write(r.content)
finally:
     file_object.close( )

