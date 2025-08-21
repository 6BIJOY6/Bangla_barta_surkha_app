
# 📱 বাংলা বার্তা সুরক্ষা অ্যাপ (Bangla SMS Safety)

*An on-device Flutter app that organizes SMS by contact/unknown senders and flags messages (Ham/Spam) using a remote ML API. Designed for Bengali users with privacy-first local storage.*

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![State](https://img.shields.io/badge/State-Hive-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## ✨ Features

- **Two-tab Inbox:**  
  - **Approved Contacts** — messages from your phonebook  
  - **Promotional/Unknown** — messages from non-contacts
- **Swipe to Move:** Dismiss (swipe) a thread to toggle between tabs; changes persist.
- **Intro Walkthrough:** Bengali onboarding with visuals and clear permission prompts.
- **Smart Highlighting (Per-message):**  
  - **Green:** Ham (safe)  
  - **Red:** Spam  
  - **Amber:** Non-Bengali content  
  - **Black:** Pending/unknown
- **Lightweight Persistent Storage:** Hive boxes for predictions cache and approved addresses.
- **Batch Predictions:** Calls a remote API (`/batch_predict/`) in batches for efficiency.
- **Privacy-aware:** Contacts and SMS stored locally; API only gets text needed for prediction.

---

## 🧱 Architecture

```mermaid
flowchart TD
  A[User] --> UI[Flutter UI]
  UI --> PERMS[Permission Handler (SMS + Contacts)]
  UI --> CONTACTS[flutter_contacts]
  UI --> SMSBOX[flutter_sms_inbox]
  SMSBOX --> GROUP[Group by Address]
  CONTACTS --> MAP[Map Numbers to Contact Names]
  GROUP --> VIEW[Tabs: Approved vs Promotional]
  VIEW --> SWIPE[Swipe to Move\n(persist to Hive)]
  VIEW --> DETAILS[Message Details Screen]
  DETAILS -->|Bangla text only| API[HTTP: /batch_predict]
  API --> CACHE[Hive predictionsMapBox]
  CACHE --> DETAILS
  VIEW --> STATE[Hive userApprovedAddressesBox]
