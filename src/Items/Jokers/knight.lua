SMODS.Joker{ --Knight
    key = "knight",
    config = {
        extra = {
        }
    },
    pos = {
        x = 4,
        y = 4,
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    order = 43,
    attributes = { 'passive', 'face' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimarii, lumahoneyy', 'sugariimarii, sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint then
            if context.other_card:is_face() then
                return {
                    add_to_hand = true,
                }
            end
        elseif context.debuff_card and not context.blueprint then
            if context.debuff_card:is_face() then
                return {
                    prevent_debuff = true,
                }
            end
        end
    end
}
