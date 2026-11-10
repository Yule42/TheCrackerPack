SMODS.Joker{ --Darkroom
    key = "darkroom",
    config = {
        extra = {
            skips = 0,
            skips_needed = 3,
            skips_needed_base = 3,
        }
    },
    pos = {
        x = 3,
        y = 2
    },
    order = 17,
    attributes = { 'generation', 'scaling', 'reset', 'tag' },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        local negative_count = 0
        if G.jokers then
            for k, v in ipairs(G.jokers.cards) do
                if v and v.edition and v.edition.negative then
                    negative_count = negative_count + 1
                end
            end
        end
        card.ability.extra.skips_needed = card.ability.extra.skips_needed_base + negative_count
        return {vars = {card.ability.extra.skips, card.ability.extra.skips_needed}}
    end,
    
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.skips_needed_base = card.ability.extra.skips_needed_base + 1
            card.ability.extra.skips_needed = card.ability.extra.skips_needed + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_cracker_downgrade_ex_qu'),
                        colour = G.C.FILTER,
                        card = card
                    })
                    return true
                end
            }))
        elseif context.open_booster then
            if not context.blueprint then
                card.ability.extra.skips = card.ability.extra.skips + 1
            end
            local negative_count = 0
            if G.jokers then
                for k, v in ipairs(G.jokers.cards) do
                    if v and v.edition and v.edition.negative then
                        negative_count = negative_count + 1
                    end
                end
            end
            card.ability.extra.skips_needed = card.ability.extra.skips_needed_base + negative_count
            if card.ability.extra.skips >= card.ability.extra.skips_needed or (context.blueprint and context.blueprint_card.T.x < card.T.x and card.ability.extra.skips >= card.ability.extra.skips_needed - 1) then
                local card_ = context.blueprint and context.blueprint_card or card
                local original = not context.blueprint
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        if original then
                            card.ability.extra.skips = 0
                        end
                        SMODS.add_card { set = 'Joker', edition = 'e_negative', key_append = 'cracker_darkroom' }
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_joker'),
                    colour = G.C.DARK_EDITION,
                    delay = 0.45,
                }
            elseif not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = card.ability.extra.skips..'/'..card.ability.extra.skips_needed,
                            colour = G.C.FILTER,
                            delay = 0.45, 
                            card = card
                        })
                        return true
                    end}))
                return nil, true
            end
        end
    end
}
