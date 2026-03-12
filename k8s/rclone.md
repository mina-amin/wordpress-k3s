# Go to Google Cloud Console
https://console.cloud.google.com/iam-admin/serviceaccounts
```
- Click **Create Service Account**
- Name it anything (e.g. `k8s-backup`)
- Click **Create and Continue** → skip role → **Done**

---

**2. Generate the JSON key**

- Click on the service account you just created
- Go to **Keys** tab → **Add Key** → **Create new key** → **JSON**
- Download the `.json` file

---

**3. Enable Google Drive API**
```
https://console.cloud.google.com/apis/library/drive.googleapis.com
```
- Click **Enable**

---

**4. Share your Google Drive folder with the service account**

- Open the target folder in Google Drive
- Click **Share**
- Paste the service account email ( k8s-backup@praxis-index-490023-d4.iam.gserviceaccount.com )
- Give it **Editor** access

---

**5. Back in the rclone prompt — paste the path to your JSON file**
```
service_account_file> /path/to/your-service-account.json