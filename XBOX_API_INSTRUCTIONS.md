# Xbox API Interaction Guide (OpenXBL Free Key Edition)


MY XBOX API KEY IS:

d2c2a0c5-ce9b-4e59-91aa-d0a73c45ac87




**Last updated:** 16 July 2025  
This guide shows how to fetch Xbox Live data using nothing more than:

* a *free* OpenXBL **API key** (`X-Authorization` header)  
* a player‑supplied **Gamertag** (which we immediately resolve to an XUID)

All examples use plain `curl`, so they work in any language or shell.

---

## 0  Getting an API Key

1. Create an account at **<https://xbl.io>** and verify your email.  
2. Click **Dashboard → API Keys → New API Key**.  
3. Copy the generated key (looks like `abc1234...`).  

> **Header to add on every request**

```
X-Authorization: YOUR_API_KEY
Accept: application/json           # optional but recommended
```

Free keys are limited to **150 requests per hour** and cannot modify
other players’ data.

---

## 1  Quick Endpoint Reference

| Purpose | Verb | Path |
|---------|------|------|
| Search *Gamertag → XUID* | `GET` | `/api/v2/search/{gamertag}` |
| Player **profile** (gamerpic, score, bio, etc.) | `GET` | `/api/v2/account/{xuid}` |
| **Presence** (online / title playing) – your own | `GET` | `/api/v2/presence` |
| Presence of another user | `GET` | `/api/v2/presence/{xuid}` |
| **Friends** list – your own account | `GET` | `/api/v2/friends` |
| **Achievements** – your own account | `GET` | `/api/v2/achievements` |
| Achievements for any player | `GET` | `/api/v2/achievements/player/{xuid}` |
| **Game Clips** a player has shared | `GET` | `/api/v2/dvr/{xuid}` |
| **Screenshots** a player has shared | `GET` | `/api/v2/dvr/screenshots/{xuid}` |

> All paths are relative to `https://xbl.io`.

---

## 2  Workflow: From Gamertag to Full Player Bundle

```mermaid
graph LR
    A[Gamertag] --> B(/search/{gamertag})
    B -->|xuid| C(/account/{xuid})
    C --> D(/presence/{xuid})
    C --> E(/achievements/player/{xuid})
    style A fill:#f6f8fa,stroke:#555,stroke-width:1px
```

### 2‑A  Convert **Gamertag → XUID**

```bash
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/search/Chief123
```

*Parse `people[0].xuid` from the JSON.*

### 2‑B  Fetch Player Profile

```bash
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/account/2533274801175621
```

Key fields returned:

| JSON path | Meaning |
|-----------|---------|
| `.people[0].gamerPic` | URL of gamer picture |
| `.people[0].gamerscore` | Lifetime gamerscore |
| `.people[0].preferredColor.primaryColor` | Dashboard theme |
| `.people[0].bio` | Player‑supplied bio |

### 2‑C  Presence

```bash
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/presence/2533274801175621
```

Returns online state (`onlineState`), current title, and per‑device
activity.

### 2‑D  Achievements

```bash
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/achievements/player/2533274801175621
```

Each entry contains:

* `titleId`, `name`, `progressState`
* `unlockedTime` (ISO‑8601) if earned
* `mediaAssets[]` (artwork URLs)

---

## 3  Friends and Social Graph (Authenticated User Only)

The endpoints below **require** that the **calling account owns the API
key**. You cannot retrieve another player’s friends list without their
App Key.

### Friends List

```bash
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/friends
```

### Presence of Friends

```bash
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/presence
```

---

## 4  Game Capture (Optional)

```bash
# Latest screenshots a player shared publicly
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/dvr/screenshots/2533274801175621

# Game clips (videos)
curl -H "X-Authorization:$KEY" \
     https://xbl.io/api/v2/dvr/2533274801175621
```

---

## 5  Putting It All in One Script (Node.js)

```js
import fetch from "node-fetch";

const KEY = process.env.OPENXBL_KEY;
const BASE = "https://xbl.io/api/v2";

const headers = { "X-Authorization": KEY };

async function gamertagToXuid(tag) {
  const res = await fetch(`${BASE}/search/${encodeURIComponent(tag)}`, { headers });
  const json = await res.json();
  return json.people?.[0]?.xuid;
}

async function getBundle(gamertag) {
  const xuid = await gamertagToXuid(gamertag);
  if (!xuid) throw new Error("Gamertag not found");

  const [profile, presence, achievements] = await Promise.all([
    fetch(`${BASE}/account/${xuid}`, { headers }).then(r => r.json()),
    fetch(`${BASE}/presence/${xuid}`, { headers }).then(r => r.json()),
    fetch(`${BASE}/achievements/player/${xuid}`, { headers }).then(r => r.json())
  ]);

  return { xuid, profile, presence, achievements };
}
```

---

## 6  Error Handling & Limits

| HTTP Code | Likely Cause | Remedy |
|-----------|-------------|--------|
| **401/403** | Missing or invalid `X-Authorization` | Check key, header spelling |
| **404** | Gamertag/XUID not found | Validate input |
| **429** | Rate limit exceeded | Wait & retry (150 req/h for free keys) |
| **5xx** | OpenXBL upstream error | Retry with exponential back‑off |

---

## 7  Cheat‑Sheet: cURL Templates

```bash
# Replace <> parts before running

TAG="Chief123"
XUID="2533274801175621"
KEY="paste_your_key_here"

# Search
curl -H "X-Authorization:$KEY" https://xbl.io/api/v2/search/$TAG

# Profile
curl -H "X-Authorization:$KEY" https://xbl.io/api/v2/account/$XUID

# Presence
curl -H "X-Authorization:$KEY" https://xbl.io/api/v2/presence/$XUID

# Achievements
curl -H "X-Authorization:$KEY" https://xbl.io/api/v2/achievements/player/$XUID
```

---

### Useful Links

* OpenXBL Docs: <https://xbl.io/docs>  
* OpenXBL API Console (try requests in‑browser): <https://xbl.io/console>

---

*Happy coding & may your gamerscore keep climbing!*  
