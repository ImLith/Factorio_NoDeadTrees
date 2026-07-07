# No Dead Trees 🌳

A small Factorio QoL mod that keeps player-planted trees green while preserving their natural pollution absorption.

## About

In Space Age, trees planted using tree seeds behave like normal trees:
- They grow naturally
- They absorb pollution
- They help clean the environment

However, pollution eventually causes them to lose their leaves and become dead-looking.

No Dead Trees prevents this visual change by refreshing protected trees before they become bare, while keeping their normal pollution absorption behavior.

## Features

✅ Player-planted trees remain green  
✅ Trees continue absorbing pollution normally  
✅ Persistent protection across save reloads  
✅ Lightweight periodic checking  
✅ Configurable check interval  
✅ Optional debug logging  
✅ Localization support  

## How it works

The mod tracks trees planted by the player.

Every configured interval, tracked trees are checked. If pollution causes the tree to enter a damaged visual stage, it is refreshed back to its healthy state.

The tree is not replaced with a decorative object and continues functioning as a normal tree.

## Configuration

### Tree Check Interval

Controls how often protected trees are checked.

### Debug Logging

Enables additional information useful for troubleshooting.

## Known limitations

- Currently only protects player-planted trees.
- Naturally generated trees are unaffected.
- Trees are refreshed visually when pollution removes their leaves.

## License

MIT License