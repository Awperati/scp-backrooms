# Entity System Documentation

## Overview
The SCP Backrooms game uses a base entity system that provides common functionality for all game entities. The `entity_base.gd` script serves as the foundation for all entities in the game.

## Key Features

### 1. Basic Entity Properties
- `entity_type`: Type identifier for the entity
- `health`: Current health of the entity
- `max_health`: Maximum health of the entity
- `speed`: Movement speed
- `detection_range`: Range at which the entity detects the player
- `attack_range`: Range at which the entity can attack
- `damage`: Damage dealt by the entity

### 2. Health and Damage System
- `take_damage(amount)`: Apply damage to the entity
- `heal(amount)`: Restore health to the entity
- `set_health(new_health)`: Set health to a specific value
- `get_health_percentage()`: Get current health as a percentage

### 3. Game State Management
- `is_active`: Whether the entity is active in the game
- `is_alive`: Whether the entity is alive
- `set_active(active)`: Set the entity's active state
- `get_active()`: Get the entity's active state

### 4. Entity Lifecycle
- `kill_entity()`: Handle entity death and cleanup
- Signals for health changes, damage, and death

### 5. Utility Methods
- `get_distance_to_player()`: Get distance to player
- `is_player_in_range(range)`: Check if player is within range
- `get_entity_info()`: Get comprehensive entity information

## Usage

To create a new entity that inherits from the base class:

```gdscript
extends "res://scripts/entity_base.gd"

func _ready():
    super._ready()
    # Additional initialization code

func _process(delta):
    super._process(delta)
    # Custom behavior code

# Override signals as needed
func _on_health_changed(new_health: float, max_health: float):
    # Handle health changes

func _on_entity_damaged(amount: float, new_health: float):
    # Handle damage

func _on_entity_killed(entity):
    # Handle death
```

## Signals
- `health_changed(new_health, max_health)`: Emitted when health changes
- `entity_damaged(amount, new_health)`: Emitted when entity takes damage
- `entity_killed(entity)`: Emitted when entity dies

## Integration with Game Systems
The base class automatically integrates with:
- `entity_manager` (manages all active entities)
- `game_controller` (manages game state)
- `player` (references the player entity)