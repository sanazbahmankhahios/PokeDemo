# PokeDex

![UIKit](https://img.shields.io/badge/UIKit-✅-orange) ![iOS](https://img.shields.io/badge/iOS-18.1-blue)

**PokemonDemo** is an iOS application implemented using **UIKit** and follows the **MVVM-C architecture pattern**.

---

## Features

- **Async/await** is used to fetch data from the PokeAPI for smooth and efficient asynchronous loading.
- **Kingfisher** (via Swift Package Manager) efficiently loads and caches Pokémon images.
- The main screen displays a **paginated grid of Pokémon**, showing their names and images fetched from the PokeAPI.
- **CollectionView** is used for adaptive layouts, supporting different device sizes and orientations.
- Selecting a Pokémon navigates to a **detail screen**, showing its image and six unique descriptions.
- **Dependency Injection** is implemented for services and view models.
- Unit tests are written for **ViewModels** and key service logic using **mocked services** to ensure reliability.
- Users can mark Pokémon as **favorites**, with updates sent through a POST request webhook.
- The project uses Git for version control and collaborative development.

---

## Screenshots

### Main Screen
<p float="left">
  <img src="https://github.com/user-attachments/assets/6b3f0240-ff68-476a-b0bd-b3afb32d0adc" width="350" />
  <img src="https://github.com/user-attachments/assets/37b749ca-9d42-422a-9039-21b4a4fb5fed" width="350" />
</p>

### Detail Screen
<p float="left">
  <img src="https://github.com/user-attachments/assets/b8dd6011-452f-460a-8b2c-0090433d7caa" width="350" />
  <img src="https://github.com/user-attachments/assets/490e3ad7-96ed-48bf-af8b-fc489e238eda" width="350" />
</p>


## Demo Video

https://github.com/user-attachments/assets/eeea0fa1-042e-408d-8b35-4693168feabf
