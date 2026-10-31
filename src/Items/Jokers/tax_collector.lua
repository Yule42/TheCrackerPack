SMODS.Joker{ -- Tax Collector
    key = "tax_collector",
    config = {
        extra = {
        }
    },
    pos = {
        x = 1,
        y = 5
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    order = 41,
    attributes = { 'mult' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = { }}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == "unscored" then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                }
            else
                return { mult = math.floor(context.other_card:get_chip_bonus()/2) }
            end
        end
    end,
}
