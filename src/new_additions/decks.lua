SMODS.Back{ -- Showdown Deck
    name = "Showdown Deck", 
    key = "showdown",
    
    pos = {
        x = 5,
        y = 0,
    },
    atlas = 'Backs',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.extra_reward = 2
    end,
}
