from google.cloud import storage
from datetime import datetime

#inputs
import sys
import os
file_path = sys.argv[1]
full_name = os.path.basename(file_path)
file_name = os.path.splitext(full_name)
print("input ruta file for to upload: ", sys.argv[1])

#vars settings
gcpserviceaccountpath = "./serviceaccount.json"
bucketname = "ora-tiex-backup"
fileintothebucket = full_name
filetouploadlocalpath = sys.argv[1]


# Authenticate ourselves using the service account private key
path_to_private_key = gcpserviceaccountpath
client = storage.Client.from_service_account_json(json_credentials_path=path_to_private_key)

bucket = storage.Bucket(client, bucketname)
# Name of the file on the GCS once uploaded
blob = bucket.blob(fileintothebucket)
# Path of the local filee
blob.upload_from_filename(filetouploadlocalpath)
now = datetime.now()
print(now, "- upload (", filetouploadlocalpath, ") success")
