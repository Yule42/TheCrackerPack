SMODS.Voucher {
    key = 'paperback_pw_proud',
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = true,
    cost = 15,
    in_pool = function(self, args)
        if G.GAME.selected_back.effect.center.key == 'b_cracker_patchwork' then
            return true
        end
    end,
    config = {
        extra = {
        }
    },
    dependencies = 'paperback',
    prefix_config = {
        key = { 
            mod = false
        },
        atlas = false,
    },
    atlas = 'paperback_decks_atlas',
    pools = { DeckVoucher = true },
    no_collection = true,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Deck Voucher', G.C.FILTER, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', key = 'patchwork_only'} end
        return {vars = {}}
    end,
    redeem = function(self, card)
        local ranks = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'}
        local suits = {'paperback_Stars', 'paperback_Crowns'}
        for _, suit in ipairs(suits) do
            for _, rank in ipairs(ranks) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.05,
                    func = function()
                        local card = SMODS.add_card({set = 'Base', area = G.deck, suit = suit, rank = rank})
                        return true
                    end
                }))
            end
        end
        G.GAME.starting_deck_size = G.GAME.starting_deck_size + 26
    end
}
