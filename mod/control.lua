
local utils = require("lib/utils")
local tree_tracking = require("lib/tree_tracking")

local function init()
    utils.init_tracking()
    tree_tracking.initialize_schedule()
end

script.on_init(function()
    init()
end)

script.on_configuration_changed(function()
    init()
end)

tree_tracking.register_events()
