# CombatModule

A comprehensive combat mechanics system for Roblox games providing knockback, ragdoll, and character control utilities.

## Features

- **Multiple Knockback Types**: Strong directional, upward, and positional knockback
- **Ragdoll System**: Integrated with CollectionService for easy state management
- **Character Disabling**: Temporary character control disabling
- **Physics Integration**: Uses BodyVelocity and BodyPosition for smooth effects
- **Automatic Cleanup**: Built-in debris management for memory efficiency

## Installation

1. Copy `CombatModule.lua` to your `ReplicatedStorage.Libraries` folder
2. Require the module in your scripts:

```lua
local Combat = require(game.ReplicatedStorage.Libraries.CombatModule)
```

## API Reference

### Combat.StrongKnockback(target, strength1, strength2, duration, Origin)
Apply strong directional knockback to a target.

**Parameters:**
- `target` (BasePart): The part to apply knockback to
- `strength1` (number): Minimum knockback strength
- `strength2` (number): Maximum knockback strength  
- `duration` (number): How long the knockback lasts
- `Origin` (BasePart): The part determining knockback direction

**Example:**
```lua
-- Apply random knockback between 50-100 strength for 1.5 seconds
Combat.StrongKnockback(enemyHRP, 50, 100, 1.5, playerHRP)
```

### Combat.UpKnockback(target, strength1, strength2, duration, Origin)
Apply upward knockback to launch targets into the air.

**Parameters:** Same as StrongKnockback but uses UpVector instead of LookVector

**Example:**
```lua
-- Launch enemy upward with random strength
Combat.UpKnockback(enemyHRP, 30, 60, 2.0, playerHRP)
```

### Combat.Ragdoll(target, duration)
Apply ragdoll effect using CollectionService tags.

**Parameters:**
- `target` (Model): The character to ragdoll
- `duration` (number): How long to ragdoll for

**Example:**
```lua
-- Ragdoll enemy for 3 seconds
Combat.Ragdoll(enemyCharacter, 3.0)
```

### Combat.InsertDisabled(Target, Duration)
Temporarily disable a character by adding a "Disabled" tag.

**Parameters:**
- `Target` (Model): The character to disable
- `Duration` (number): How long to disable for

**Example:**
```lua
-- Disable player controls for 2 seconds
Combat.InsertDisabled(playerCharacter, 2.0)
```

### Combat.Knockback(PlayerHRP, Target, ZDistance, YDistance)
Apply positional knockback to move target to specific relative location.

**Parameters:**
- `PlayerHRP` (BasePart): The origin point for calculations
- `Target` (BasePart): The target to move
- `ZDistance` (number): Distance in Z direction
- `YDistance` (number): Distance in Y direction (currently unused)

**Example:**
```lua
-- Push target 10 studs away
Combat.Knockback(playerHRP, enemyHRP, -10, 0)
```

## Dependencies

- **CollectionService**: For ragdoll state management
- **Debris**: For automatic cleanup of temporary objects

## Integration Examples

### Basic Combat System
```lua
local Combat = require(game.ReplicatedStorage.Libraries.CombatModule)

-- On hit event
local function onPlayerHit(attacker, target, attackType)
    if attackType == "heavy" then
        Combat.StrongKnockback(target.HumanoidRootPart, 75, 125, 1.5, attacker.HumanoidRootPart)
        Combat.InsertDisabled(target, 1.0)
    elseif attackType == "uppercut" then
        Combat.UpKnockback(target.HumanoidRootPart, 50, 80, 2.0, attacker.HumanoidRootPart)
    elseif attackType == "slam" then
        Combat.Ragdoll(target, 2.5)
    end
end
```

### Advanced Combo System
```lua
local Combat = require(game.ReplicatedStorage.Libraries.CombatModule)
local Players = game:GetService("Players")

local comboTracker = {}

local function executeCombo(player, target, comboStage)
    local playerHRP = player.Character.HumanoidRootPart
    local targetHRP = target.Character.HumanoidRootPart
    
    if comboStage == 1 then
        -- Light knockback
        Combat.StrongKnockback(targetHRP, 25, 35, 0.8, playerHRP)
    elseif comboStage == 2 then
        -- Medium knockback  
        Combat.StrongKnockback(targetHRP, 40, 60, 1.0, playerHRP)
    elseif comboStage == 3 then
        -- Finisher: ragdoll + strong knockback
        Combat.Ragdoll(target.Character, 1.5)
        Combat.StrongKnockback(targetHRP, 80, 120, 1.8, playerHRP)
        comboTracker[player] = nil -- Reset combo
    end
end
```

## Performance Notes

- **Memory Usage**: Low - uses minimal memory footprint
- **CPU Usage**: Low - simple calculations with automatic cleanup
- **Network Usage**: None - operates locally with physics

## Version History

- **v2.1.0**: Added comprehensive documentation and examples
- **v2.0.0**: Integrated CollectionService for ragdoll management
- **v1.0.0**: Initial release with basic knockback functionality

## License

MIT License - Feel free to use in your projects
