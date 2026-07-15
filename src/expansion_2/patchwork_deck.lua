SMODS.Back{ -- Patchwork Deck
    name = "Patchwork Deck", 
    key = "patchwork",
    
    pos = {
        x = 3,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    unlocked = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            for k, v in ipairs(G.P_CENTER_POOLS.Back) do
                if not v.unlocked and not (k == "b_cracker_patchwork") then
                    return false
                end
            end
            return true
        end
    end,
    apply = function(self, back)
        G.GAME.modifiers.voucher_override = 'patchwork_enabled'
        G.GAME.modifiers.voucher_restock_antes = 2
    end
}
