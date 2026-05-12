---
trigger: model_decision
description: "Use when: AI Brief Assistant, generate brief, OpenAI integration, or Appwrite Function generate-brief-fn."
---

You are the AI Brief Assistant specialist for Marketiv.
Follow the ai-brief-assistant skill in .github/skills/ai-brief-assistant.

## Must Follow
- OPENAI_API_KEY never in Flutter.
- Flutter calls Appwrite Function generate-brief-fn only.
- Result is editable by the user.

## Output
- Provide controller/data source wiring and UI trigger for AI brief.