# 🎧 Kiloview Intercom Server Installer

Welcome to the official script to install **Kiloview Intercom Server (KIS)** on your cloud or on-premise machine.  
KIS is your flexible, powerful and scalable solution to **enable real-time IP-based audio intercom** with party-line capabilities.

---

## ⚙️ Quick Installation

Paste the following command into your terminal:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/simonemessina92/KIS/main/KIS_install.sh)

This script will:

✅ Check required dependencies (curl, docker)  
📦 Download and install the latest stable version of Kiloview Intercom Server  
🐳 Run the container with the correct volume mappings and network settings  
🌐 Automatically tell you where to access the Web UI  
🔐 Set up with default credentials: admin / admin (you'll be prompted to change password at first login)

🔗 Access the Web UI  
Once installed, simply open your browser and go to:

Default web UI access  
https://<YOUR_SERVER_IP>:8443

The default login is:

Default username and password  
Username: admin  
Password: admin  
At first login, you’ll be asked to define a new password.

🆕 Check for Updates  
New versions of KIS firmware can be downloaded from:

👉 https://www.kiloview.com/en/support/download/

You can upload the .bin file directly via the Web UI to upgrade your deployment.

💡 About Kiloview  
Kiloview is your AVoIP Trailblazer – delivering reliable, scalable and intuitive solutions to help you manage video and intercom over IP with ease.

🔍 Learn more at https://www.kiloview.com/en

❤️ Credits  
Made with 💙 by @simonemessina92
```
