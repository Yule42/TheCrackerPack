SMODS.Joker{ --Rainbow Card
    name = "Rainbow Card",
    key = "rainbowcard",
    config = {
        extra = {
            retriggers = 1,
            active = true,
        }
    },
    pos = {
        x = 0,
        y = 3
    },
    order = 21,
    attributes = { 'retrigger' },
    cost = 9,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        local has_message = (G.GAME and card.area and (card.area == G.jokers))
        info = nil
        if has_message then
            local active = card.ability.extra.active
            info = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "m", colour = active and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(active and 'k_active' or 'k_cracker_inactive')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                    }}
                }}
            }
        end
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade','sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.retriggers}, main_end = info}
    end,
    
    calculate = function(self, card, context)
        if context.round_eval and not card.ability.extra.active and not context.blueprint then
            card.ability.extra.active = true
            return {
                message = localize('k_reset'),
                colour = G.C.FILTER,
                card = card,
            }
        elseif context.cracker_taking_booster_card and card.ability.extra.active and G.shop and not context.blueprint then
            card.ability.extra.active = false
            G.E_MANAGER:add_event(Event({
                func = (function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_cracker_inactive_ex'),
                        colour = G.C.FILTER,
                        delay = 0.45, 
                        card = card
                    })
                    return true
                end)
            }))
        elseif context.repetition and (context.cardarea == G.play or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1))) and not context.repetition_only and card.ability.extra.active then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
            }
        end
    end
}
