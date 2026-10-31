SMODS.Joker{ --Life Support
    key = "lifesupport",
    config = {
        extra = {
            price = 5,
        }
    },
    pos = {
        x = 5,
        y = 1
    },
    order = 12,
    attributes = { 'mult', 'chips', 'scaling', 'hands' },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.price}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and not context.blueprint then
            local maxim = math.max(to_big(hand_chips), to_big(mult))
            hand_chips = maxim
            mult = maxim
            update_hand_text({ delay = 0 }, { mult = mult, chips = hand_chips })
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_cracker_maximized_ex'), colour = { 0.8, 0.45, 0.85, 1 }, sound = 'gong', pitch = 0.94 })
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    ease_colour(G.C.UI_CHIPS, { 0.8, 0.45, 0.85, 1 })
                    ease_colour(G.C.UI_MULT, { 0.8, 0.45, 0.85, 1 })
                    ease_dollars(-card.ability.extra.price, true)
                    card.ability.extra.price = card.ability.extra.price * 2
                    card:juice_up(0.3, 0.4)
                    if G.GAME.dollars < 0 then
                        SMODS.destroy_cards(card, { pinch_anim = true })
                    end
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay = 4.3,
                        func = (function()
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 1)
                            ease_colour(G.C.UI_MULT, G.C.RED, 1)
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay = 6.3,
                        func = (function()
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true
                        end)
                    }))
                    return true
                end)
            }))
            return nil, true
        end
    end
}
