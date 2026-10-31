SMODS.Joker{ --Postman
    name = "Postman",
    key = "postman",
    config = {
        extra = {
            dollars = 2,
        }
    },
    pos = {
        x = 9,
        y = 3,
    },
    order = 37,
    attributes = { 'economy', 'seals' },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.seal then
                return true
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'palestjade'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.dollars}}
    end,
    
    calculate = function(self, card, context)
        if context.cracker_seal_trigger then
            return {
                dollars = card.ability.extra.dollars,
            }
        end
    end
}
