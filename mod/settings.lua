data:extend({
    {
        type = "int-setting",
        name = "no-dead-trees-refresh-interval",
        setting_type = "runtime-global",
        default_value = 10,
        minimum_value = 1,
        maximum_value = 3600,
        order = "a",
        localised_name = {"mod-setting-name.no-dead-trees-refresh-interval"},
        localised_description = {"mod-setting-description.no-dead-trees-refresh-interval"}
    },
    {
        type = "bool-setting",
        name = "no-dead-trees-debug-logging",
        setting_type = "runtime-global",
        default_value = false,
        order = "b",
        localised_name = {"mod-setting-name.no-dead-trees-debug-logging"},
        localised_description = {"mod-setting-description.no-dead-trees-debug-logging"}
    }
})
