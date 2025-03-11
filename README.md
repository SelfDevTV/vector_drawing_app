# Vector Drawing App

## Description
A simple LÖVE (Love2D) application for creating and manipulating vectors on a 2D plane. It uses [systems/coordinateSystem.lua](systems/coordinateSystem.lua) to handle grid-related logic and [systems/inputSystem.lua](systems/inputSystem.lua) to manage user mouse interactions with vectors.

## Features
- Create vectors by clicking and dragging on the canvas.
- Select and move existing vectors or individual endpoints.
- Snap vectors to a grid on mouse release.
- Visual highlighting for selected vectors.

## Setup & Usage
1. Install LÖVE from the official website.
2. Clone or download this repository.  
3. Run the project with:  
   ```sh
   love .
   ```
4. Click and drag to draw vectors.  
5. Move endpoints or entire vectors by clicking and dragging them.

## Project Structure
- [main.lua](main.lua): Contains the main Love2D callbacks.  
- [systems/coordinateSystem.lua](systems/coordinateSystem.lua): Manages grid drawing and coordinate transformations.  
- [systems/inputSystem.lua](systems/inputSystem.lua): Handles mouse input, vector creation, and movement.  
- [entities/Point.lua](entities/Point.lua): Defines the Point entity.  
- [entities/Vec.lua](entities/Vec.lua): Defines the Vec entity (a line with two endpoints).  
- [libs/class.lua](libs/class.lua), [libs/inspect.lua](libs/inspect.lua), [libs/vector.lua](libs/vector.lua): External libraries for object-oriented structure, debugging, and basic vector math.