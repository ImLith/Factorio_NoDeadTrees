local constants = require("lib/constants")
local utils = require("lib/utils")

local tree_tracking = {}
local events_registered = false

local function get_check_interval()
    return utils.get_refresh_interval() * 60
end

local function ensure_schedule()
    storage.no_dead_trees_state = storage.no_dead_trees_state or {}

    if not storage.no_dead_trees_state.next_refresh_tick then
        storage.no_dead_trees_state.next_refresh_tick = game.ticks_played + get_check_interval()
    end
end

local function describe_tree(entity)
    return entity.name .. " at "
        .. math.floor(entity.position.x)
        .. ","
        .. math.floor(entity.position.y)
end

function tree_tracking.add_tree(entity)
    local trees = utils.get_tree_storage()
    table.insert(trees, entity)

    utils.log("Tracked planted tree: " .. describe_tree(entity))
end

function tree_tracking.remove_tree(entity)
    local trees = utils.get_tree_storage()

    for i = #trees, 1, -1 do
        if trees[i] == entity then
            table.remove(trees, i)
            utils.log("Removed tree from tracking")
            return true
        end
    end

    return false
end

function tree_tracking.handle_built_entity(event)
    local entity = event.entity

    if not event.player_index then
        return
    end

    if utils.is_tree(entity) then
        tree_tracking.add_tree(entity)
    end
end

function tree_tracking.handle_mined_entity(event)
    if utils.is_tree(event.entity) then
        tree_tracking.remove_tree(event.entity)
    end
end

function tree_tracking.refresh_trees()
    local trees = utils.get_tree_storage()

    if not trees or #trees == 0 then
        return
    end

    local refreshed = 0
    local removed = 0

    for i = #trees, 1, -1 do
        local tree = trees[i]

        if not tree or not tree.valid then
            table.remove(trees, i)
            removed = removed + 1
        else
            local stage = tree.tree_stage_index

            if stage and stage > 1 then
                tree.tree_stage_index = 1
                refreshed = refreshed + 1
            end
        end
    end

    if refreshed > 0 then
        utils.log("Restored " .. refreshed .. " damaged trees")
    end

    if removed > 0 then
        utils.log("Removed " .. removed .. " invalid trees from tracking")
    end
end

function tree_tracking.register_events()
    if events_registered then
        return
    end

    events_registered = true

    script.on_event(defines.events.on_built_entity, function(event)
        tree_tracking.handle_built_entity(event)
    end)

    script.on_event(defines.events.on_pre_player_mined_item, function(event)
        tree_tracking.handle_mined_entity(event)
    end)

    script.on_event(defines.events.on_robot_pre_mined, function(event)
        tree_tracking.handle_mined_entity(event)
    end)

    script.on_event(defines.events.on_tick, function()
        ensure_schedule()

        if game.ticks_played >= storage.no_dead_trees_state.next_refresh_tick then
            tree_tracking.refresh_trees()

            storage.no_dead_trees_state.next_refresh_tick =
                game.ticks_played + get_check_interval()
        end
    end)
end

function tree_tracking.initialize_schedule()
    ensure_schedule()
end

function tree_tracking.on_runtime_mod_setting_changed(event)
    if event and event.setting == constants.SETTING_REFRESH_INTERVAL then
        storage.no_dead_trees_state = storage.no_dead_trees_state or {}
        storage.no_dead_trees_state.next_refresh_tick = game.ticks_played + get_check_interval()
        utils.log("Refresh interval set to " .. utils.get_refresh_interval() .. " seconds")
    end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    tree_tracking.on_runtime_mod_setting_changed(event)
end)

return tree_tracking
