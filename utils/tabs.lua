SMODS.current_mod.extra_tabs = function() --Credits
    local scale = 0.4
    return {
        label = "Credits",
        tab_definition_function = function()
        return {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                padding = 0.05,
                colour = G.C.CLEAR,
            },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Directors: sugariimarii, sophiedeergirl",
                                shadow = false,
                                scale = scale,
                                colour = G.C.GREEN
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Art: palestjade, MrkySpices, amoryax, LumaHoneyy, vyletbunni, sugariimarii, gfsg",
                                shadow = false,
                                scale = scale,
                                colour = G.C.BLUE
                            }
                        },
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Programming: sophiedeergirl, I'm an issue",
                                shadow = false,
                                scale = scale,
                                colour = G.C.GREEN
                            }
                        }
                    },
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Testing: brook03, plebmiester",
                                shadow = false,
                                scale = scale,
                                colour = G.C.MONEY
                            }
                        }
                    },
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Joker Ideas: sophiedeergirl, sugariimarii, palestjade, brook03, plebmiester",
                                shadow = false,
                                scale = scale,
                                colour = G.C.GREEN
                            }
                        }
                    },
                },
                {
                    n = G.UIT.R,
                    config = {
                        padding = 0,
                        align = "cm"
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = "Contribution: DistantMind, wombatcountry, courier, elpapud6, GeorgeTheRat, Infamousinvictis",
                                shadow = false,
                                scale = scale,
                                colour = G.C.SECONDARY_SET.Spectral
                            }
                        }
                    },
                },
            }
        }
        end
    }
end

SMODS.current_mod.config_tab = function() --Config
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        {
            n = G.UIT.R,
            config = {
                padding = 0,
                align = "cm"
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = "All changes require a restart.",
                        shadow = false,
                        scale = 0.5,
                        colour = G.C.SECONDARY_SET.Enhanced
                    }
                },
            }
        },
        create_toggle({
            label = "Dev Textures",
            ref_table = CrackerConfig,
            ref_value = "starlo",
        }),
      },
    }
end
