SMODS.Joker{ -- Sailor
    key = "sailor",
    config = {
        extra = {
            planets = 0,
            planets_max = 3
        }
    },
    pos = {
        x = 6,
        y = 4
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Infamousinvictis', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.planets, card.ability.extra.planets_max}}
    end,
    order = 22,
    attributes = { 'hand_level', 'planet' },
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            if not context.retrigger_planet_cards then
                if not context.blueprint then
                    card.ability.extra.planets = card.ability.extra.planets + 1
                end
                if card.ability.extra.planets >= card.ability.extra.planets_max or (context.blueprint and context.blueprint_card.T.x < card.T.x and card.ability.extra.planets == card.ability.extra.planets_max - 1) then
                    SMODS.calculate_context({using_consumeable = true, consumeable = context.consumeable, area = context.from_area, retrigger_planet_cards = true})
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_again_ex'), colour = G.C.FILTER})
                    context.consumeable:use_consumeable(context.area)
                    if not context.blueprint then
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                card.ability.extra.planets = 0
                                return true
                        end}))
                    end
                    return nil, true
                elseif not context.blueprint then
                    return {
                        message = card.ability.extra.planets..'/'..card.ability.extra.planets_max
                    }
                end
            end
        end
    end
}
