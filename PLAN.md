# NoDeadTrees Mod Plan

## Goal
Create a small Space Age-compatible Factorio mod that makes trees planted manually, including through the Space Age tree seed item, immune to pollution-based death.

## Scope
- Affect only trees that are planted by the player or by the tree seed interaction.
- Leave naturally spawned or existing trees unchanged.
- Keep the implementation lightweight and focused on one behavior: pollution will not kill these specially planted trees.

## Proposed Behavior
- When a tree is placed manually or created through the tree seed item, the mod marks that tree as "protected".
- While that protection flag is active, pollution damage will not cause the tree to die.
- Trees that were not planted through this flow keep their normal behavior.

## High-Level Approach
1. Add a small mod entry point for the Space Age dependency and script logic.
2. Detect when a tree is created from a player action or from the tree seed item flow.
3. Store a lightweight marker for that tree so the mod can identify it later.
4. Intercept the pollution damage path for trees and skip the death effect when the marker is present.
5. Clean up the marker if the tree is removed so no stale state remains.

## Implementation Notes
- The mod will use a simple custom flag or lookup table rather than changing the tree prototype itself.
- The design avoids broad changes to tree growth, tree health, or unrelated entities.
- The behavior will be limited to the specific planting cases requested.

## Files to Add
- info.json
- control.lua
- README.md

## Validation Plan
- Load the mod in a test save with the Space Age DLC enabled.
- Plant a tree manually and confirm it survives pollution.
- Plant a tree using the tree seed item and confirm it also survives pollution.
- Confirm that ordinary trees still behave normally.

## Notes
This plan is intentionally narrow and focused on the requested feature. It is designed to be easy to test and easy to adjust if you want a slightly different behavior later.
