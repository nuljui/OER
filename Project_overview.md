OER project overview
Phase 1: Discovery & Planning

✅ 1. Gather Requirements
	•	Review all screenshots and notes from the company.
	•	For each page, list:
	•	UI components (inputs, buttons, tables, etc.)
	•	Expected interactions (e.g., “submit form → save on chain”)

✅ 2. Categorize Interactions
	•	Determine which interactions are:
	•	Frontend-only (e.g., animations, modals)
	•	Off-chain (e.g., client-side filters, image uploads to IPFS)
	•	On-chain (must result in a blockchain write/read via Stability)

⸻

🧱 Phase 2: Architecture & Tools

🖼️ Frontend (FE)
	•	Tech Stack: React + Tailwind (or similar)
	•	State management: Zustand, Redux, or simple React context
	•	Blockchain integration:
	•	Direct POST requests to Stability’s RPC endpoint (no ethers.js needed)
	•	Use fetch/XHR to send raw JSON

🚫 Backend (BE)
	•	Stability is backend-less: All critical writes and reads should go on-chain.
	•	Only consider using a backend if:
	•	You need private computation (auth, secret keys)
	•	Heavy file processing or IPFS pinning

🔗 On-Chain (Smart Contracts)
	•	Use Solidity
	•	Each major object type (e.g., User, Submission, Score, Vote, etc.) gets its own smart contract or struct
	•	Each contract should:
	•	Allow relevant writes (e.g., registerUser, submitEntry, vote)
	•	Store structs in mappings
	•	Emit events for off-chain read syncing