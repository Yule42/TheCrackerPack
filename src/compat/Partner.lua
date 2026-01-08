Partner_API.Partner{
    key = "pride",
    name = "Pride Partner",
    unlocked = true,
    discovered = true,
    pos = {x = 0, y = 0},
    loc_txt = {},
    atlas = "Partner",
    config = {extra = {active = true, spend = 9, spent = 0}},
    link_config = {j_cracker_rainbowcard = 1},
    loc_vars = function(self, info_queue, card)
        local link_level = self:get_link_level()
        local key = self.key
        if link_level == 1 then key = key.."_"..link_level end
        return { key = key, vars = {card.ability.extra.spend, card.ability.extra.spent} }
    end,
    calculate = function(self, card, context)
        if context.repetition and ((context.cardarea == G.play and context.other_card == context.scoring_hand[1]) or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) and context.other_card == G.hand.cards[1])) and not context.repetition_only and (card.ability.extra.active or self:get_link_level() == 1) then
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
            }
        elseif card.ability.extra.active and not self:get_link_level() == 1 and context.money_altered and context.from_shop and context.amount < 0 and not context.blueprint then
            card.ability.extra.spent = card.ability.extra.spent - context.amount
            if card.ability.extra.spent >= card.ability.extra.spend then
                card.ability.extra.active = false
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_inactive_ex'),
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end)
                }))
            end
        elseif context.end_of_round and not self:get_link_level() == 1 and not context.repetition and not context.individual and not context.blueprint then
            card.ability.extra.active = true
            card.ability.extra.spent = 0
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER,
                card = card,
            }
        end
    end,
    check_for_unlock = function(self, args)
        return true
        --[[for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_trading" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end--]]
    end,
}

Partner_API.Partner{
    key = "performer",
    name = "Performer Partner",
    unlocked = true,
    discovered = true,
    pos = {x = 1, y = 0},
    loc_txt = {},
    atlas = "Partner",
    config = {extra = {hands_normal = 1, hands_upgraded = 3, active = false}},
    link_config = {j_cracker_knifethrower = 1},
    loc_vars = function(self, info_queue, card)
        return { vars = {self:get_link_level() == 1 and card.ability.extra.hands_upgraded or card.ability.extra.hands_normal} }
    end,
    calculate = function(self, card, context)
        if card.ability.extra.active and context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(self:get_link_level() == 1 and card.ability.extra.hands_upgraded or card.ability.extra.hands_normal)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { self:get_link_level() == 1 and card.ability.extra.hands_upgraded or card.ability.extra.hands_normal } } }, card)
                    return true
                end
            }))
            return nil, true
        elseif context.end_of_round then
            if G.GAME.current_round.hands_left == 0 then
                card.ability.extra.active = true
            else
                card.ability.extra.active = false
            end
        end
    end,
    check_for_unlock = function(self, args)
        return true
        --[[for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_trading" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end--]]
    end,
}
