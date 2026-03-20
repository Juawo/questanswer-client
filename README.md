# 🎮 QuestAnswer - Mobile Game
![Godot](https://img.shields.io/badge/Godot-Engine-478CBF?style=for-the-badge&logo=godot-engine&logoColor=white)
![Figma](https://img.shields.io/badge/Figma-UI%20Design-F24E1E?style=for-the-badge&logo=figma&logoColor=white)
![Excalidraw](https://img.shields.io/badge/Excalidraw-Wireframes-6965DB?style=for-the-badge)

A mobile trivia game where players guess answers based on progressive hints, featuring AI-generated cards to enhance replayability.

---

## 📚 Table of Contents

- [Features](#features)
- [Gameplay Loop](#gameplay-loop)
- [Technical Decisions](#technical-decisions)
- [️Tech Stack](#tech-stack)
- [Screenshots & Design](#screenshots--design)
- [How to Run](#how-to-run)
- [Project Status](#project-status)
- [Differentials](#differentials)
- [Future Improvements](#future-improvements)
- [Related Projects](#related-projects)

---

## Features

- AI-generated trivia cards
- Progressive hint system
- Casual gameplay for groups of friends
- Dynamic card fetching from backend

### Planned Features

- Solo game mode
- Score system based on remaining hints
- Player registration and authentication
- Global leaderboard
- Round-based multiplayer (local play)

---

## Gameplay Loop

Current gameplay flow:

```text
Player selects a card
↓
Other players try to guess the answer based on hints
↓
Hints are progressively revealed
↓
A player guesses correctly
↓
The player who guessed correctly selects the next card

This creates a simple and social gameplay dynamic focused on group interaction.
```

## Technical Decisions

**API Integration via Global Script**
The game uses a global script (APIManager.gd) to centralize all backend requests, improving maintainability and separation of concerns.

**Duplicate Card Prevention**
To avoid repeated gameplay, the game stores locally the IDs of already played cards and only requests new ones from the backend.

**Backend-Driven Content**
The game relies on an external API for card generation and retrieval, enabling scalable content expansion without updating the client.

## Tech Stack
![Godot](https://img.shields.io/badge/Godot-Engine-478CBF?style=for-the-badge&logo=godot-engine&logoColor=white)
![Figma](https://img.shields.io/badge/Figma-UI%20Design-F24E1E?style=for-the-badge&logo=figma&logoColor=white)
![Excalidraw](https://img.shields.io/badge/Excalidraw-Wireframes-6965DB?style=for-the-badge)

## Screenshots & Design
#### Game Screens

#### UI/UX Sketch

## How to Run
```
Clone the repository:

git clone <REPO_URL>

Open the project in Godot Engine

Configure the API endpoint:

Open APIManager.gd

Replace the API URL with your backend URL

!! ️You need a compatible backend API. You can use the one from the related projects section.

Run the project inside Godot

(Optional) Export as APK and run on a mobile device
```

## Project Status

**Prototype** — core gameplay implemented, currently evolving with new mechanics and systems.

## Differentials

Fullstack project (Game + Backend)

Integration with AI for procedural content generation (PCGML)

Focus on replayability through dynamic content

Designed for mobile performance and scalability

## Future Improvements

- Score system based on remaining hints

- Round-based gameplay system

- Solo mode with 🔗time-based challenges

- Player authentication and cloud save

- Global and weekly leaderboards

- Sound effects and background music

- Game juice (animations, particles, feedback)

- Card theme packages (e.g., themed decks)

- Improved UI/UX transitions and polish

## Related Projects

This project is part of the QuestAnswer ecosystem:

🧠 Backend API: https://github.com/Juawo/questanswer-api

🤖 AI Card Generator: https://github.com/Juawo/questanswer-cardgen