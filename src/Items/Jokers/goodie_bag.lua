SMODS.Joker{ --Goodie Bag
    key = "goodie_bag",
    config = {
        extra = {
        }
    },
    pos = {
        x = 6,
        y = 2
    },
    order = 18,
    attributes = { 'generation' },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'gfsg', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster then
			local booster_real = context.booster
            if booster_real.create_card and type(booster_real.create_card) == "function" then
                local eval_card = context.blueprint_card or card
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function() -- consumables vs consumeables makes me hate everything
                        local _card = booster_real:create_card(booster_real, 1)
                        local message = 'k_plus_cracker_card'
                        local color = G.C.FILTER
                        if _card.set == 'Joker' or (G.P_CENTERS[_card.config and _card.config.center.key] and G.P_CENTERS[_card.config and _card.config.center.key].set) == 'Joker' then
                            _card.area = G.jokers
                            message = 'k_plus_joker'
                            color = G.C.BLUE
                        elseif _card.set == 'Base' or _card.set == 'Playing Card' or _card.set == 'Enhanced' then
                            _card.area = G.hand
                        elseif (G.P_CENTERS[_card.config and _card.config.center_key or _card.key] and G.P_CENTERS[_card.config and _card.config.center_key or _card.key].consumeable)
                            or SMODS.ConsumableTypes[_card.set]
                            or (SMODS.ObjectTypes[_card.set] and SMODS.ObjectTypes[_card.set].select_card == "consumeables")
                            or (G.P_CENTERS[_card.config and _card.config.center_key or _card.key] and G.P_CENTERS[_card.config and _card.config.center_key or _card.key].set == 'Consumeables') then
                            _card.area = G.consumeables
                            local death = _card.set or (G.P_CENTERS[_card.config and _card.config.center_key or _card.key].set) or nil
                            if death then
                                local die = string.lower(_card.set or (G.P_CENTERS[_card.config and _card.config.center_key or _card.key].set or ""))
                                if localize('k_plus_'..die) ~= "ERROR" then
                                    message = 'k_plus_'..die
                                end
                                color = G.C.SECONDARY_SET[_card.set] or G.C.FILTER
                            end
                        else
                            return true
                        end
                        if _card.area.config.card_limit and (_card.set ~= 'Base' and _card.set ~= 'Playing Card' and _card.set ~= 'Enhanced') then
                            if #_card.area.cards < _card.area.config.card_limit then
                                if _card.is and _card:is(Card) then
                                    SMODS.add_to_deck(_card)
                                else
                                    SMODS.add_card(_card)
                                end
                                card_eval_status_text(eval_card, 'extra', nil, nil, nil, {
                                    message = localize(message),
                                    colour = color
                                })
                            end
                        else
                            SMODS.add_card(_card)
                            card_eval_status_text(eval_card, 'extra', nil, nil, nil, {
                                message = localize(message),
                                colour = color
                            })
                        end
                        return true
                    end)}))
                return nil, true
            end
        end
    end
}
