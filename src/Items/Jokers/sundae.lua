SMODS.Joker{ --Sundae
    name = "Sundae",
    key = "sundae",
    config = {
        extra = {
            chips = 125,
            mult = 25,
            left = 4,
            state = 0,
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    pools = {
        Food = true,
    },
    order = 11,
    attributes = { 'mult', 'chips', 'planet', 'scaling', 'food' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        local key = "j_cracker_sundae_chips"
        if card.ability.extra.state == 1 then key = "j_cracker_sundae_mult"
        elseif card.ability.extra.state == 2 then key = "j_cracker_sundae_planet" end
        return {key = key, vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.left}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand then
            if card.ability.extra.state == 0 then
                return {
                    chips = card.ability.extra.chips,
                }
            elseif card.ability.extra.state == 1 then
                return {
                    mult = card.ability.extra.mult,
                }
            else
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Planet',
                                key_append = 'sundae'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_planet'),
                        colour = G.C.SECONDARY_SET.Planet,
                    }
                end
            end
        elseif context.after and not context.blueprint and not context.repetition then
            if card.ability.extra.state == 2 then
                local frz = Cracker.is_adjacent_to_freezer(card)
                if card.ability.extra.left - 1 > 0 or frz then
                    card.ability.extra.left = card.ability.extra.left - 1
                    SMODS.calculate_effect({message = not frz and ''..card.ability.extra.left or localize('k_cracker_frozen_ex'), colour = G.C.FILTER}, card)
                else
                    SMODS.destroy_cards(card, { pinch_anim = true })
                    return {
                        message = localize('k_melted_ex'),
                        colour = G.C.CHIPS
                    }
                end
            end
            card.ability.extra.state = card.ability.extra.state + 1
            if card.ability.extra.state > 2 then
                card.ability.extra.state = 0
                return {
                    message = localize('k_cracker_chips'),
                    colour = G.C.CHIPS
                }
            elseif card.ability.extra.state == 1 then
                return {
                    message = localize('k_mult'),
                    colour = G.C.MULT
                }
            else
                return {
                    message = localize('k_planet'),
                    colour = G.C.SECONDARY_SET.Planet 
                }
            end
        end
    end
}
