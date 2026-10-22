# CLAUDE.md

Instructions for every Claude session working in this repo.

## Project: FailSafe

Predict hard-drive failures from Backblaze Drive Stats SMART data.

- Focus on **one drive model** at a time.
- Use a **chronological train/test split**: train on earlier dates, test on later dates. Never shuffle randomly, because that lets the model peek at the future.
- Measure **lead time in days**: how many days before a drive actually fails the model flags it.

Later: a Kubernetes demo that safely drains a node once it has been flagged.

## How to work with me

- **I'm a beginner learning Python.** Explain every piece of code in plain English, line by line, with analogies.
- **Build in small steps.** Before writing code, tell me what you'll do and why, then ask me to predict the result. Only after that, write and run the code.
- **Never commit raw data files.** Commit only code and small result files. Raw Backblaze data stays local and must be covered by `.gitignore`.
- **Keep a short `LOG.md`.** At the end of each session, add an entry with:
  - what we did
  - what I learned
  - what's next
