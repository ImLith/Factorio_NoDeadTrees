local constants = require("lib/constants")

local utils = {}

function utils.is_debug_logging_enabled()
    if settings and settings.global then
        local setting = settings.global[constants.SETTING_DEBUG_LOGGING]
        if setting then
            return setting.value == true or setting == true
        end
    end

    return false
end

function utils.log(msg)
    if not utils.is_debug_logging_enabled() then
        return
    end

    if game and game.players then
        for _, player in pairs(game.players) do
            player.print(constants.LOG_PREFIX .. tostring(msg))
        end
    end
end

function utils.is_tree(entity)
    if not entity or not entity.valid then
        return false
    end

    return entity.name == "tree-plant"
end

function utils.get_tree_storage()
    storage.decorative_trees = storage.decorative_trees or {}
    return storage.decorative_trees
end

function utils.init_tracking()
    local trees = utils.get_tree_storage()
    local count = 0

    for _ in pairs(trees) do
        count = count + 1
    end

    utils.log("Initialized. Currently tracked trees: " .. count)
end

function utils.get_refresh_interval()
    local raw_value

    if settings and settings.global then
        local setting = settings.global[constants.SETTING_REFRESH_INTERVAL]
        if setting then
            raw_value = setting.value or setting
        end
    end

    local numeric_value = tonumber(raw_value)
    if numeric_value then
        return math.max(
            constants.MIN_REFRESH_INTERVAL,
            math.min(constants.MAX_REFRESH_INTERVAL, math.floor(numeric_value))
        )
    end

    return constants.DEFAULT_REFRESH_INTERVAL
end

return utils
