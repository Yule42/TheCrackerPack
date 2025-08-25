SMODS.Joker{ --Student
    name = "Student",
    key = "student",
    config = {
        extra = {
            chips = 3,
            mult = 1
        }
    },
    pos = {
        x = 0,
        y = 4,
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.config.center.key == 'm_cracker_multi' or v.config.center.key == 'm_cracker_sequenced' then
                add = true
            end
        end
    end,
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_multi
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_sequenced
        return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.repetition_only then
            if context.other_card.config.center.key == 'm_cracker_sequenced' or context.other_card.config.center.key == 'm_cracker_multi' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card,
                }
            end
        end
    end
}