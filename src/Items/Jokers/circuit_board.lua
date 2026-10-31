SMODS.Joker{ -- Circuit Board
    key = "circuit_board",
    config = {
        extra = {
            slot_copy = 1,
        }
    },
    pos = {
        x = 8,
        y = 4
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    order = 24,
    attributes = { 'copying', 'position' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Infamousinvictis', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        local main_end
        if card.area and card.area == G.jokers then
            local other_joker = G.jokers.cards[card.ability.extra.slot_copy] or nil
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
        return {vars = {card.ability.extra.slot_copy}, main_end = main_end}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not G.SETTINGS.paused and initial and not (card.area and card.area.config.collection) then
                    card.ability.extra.slot_copy = pseudorandom("cracker_circuit_board", 1, #G.jokers.cards)
                end
                return true
        end}))
    end,
    calculate = function(self, card, context)
        local other_joker = G.jokers.cards[card.ability.extra.slot_copy] or nil
        local ret = SMODS.blueprint_effect(card, other_joker, context)
        if ret then
            ret.colour = G.C.GREEN
        end
        return ret
    end
}
