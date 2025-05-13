SMODS.Joker{ --Royal Decree
    name = "Royal Decree",
    key = "royaldecree",
    config = {
        extra = {
        }
    },
    pos = {
        x = 8,
        y = 2,
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
}

-- Royal Decree use
local get_flush_ref = get_flush

function get_flush(hand)
    if not next(SMODS.find_card("j_cracker_royaldecree")) then return get_flush_ref(hand) end

  local ret = {}
  local four_fingers = next(find_joker('Four Fingers'))
  local suits = {
    "Spades",
    "Hearts",
    "Clubs",
    "Diamonds"
  }
  
  local contains_face = false
  local contains_ace = false
  
  
  if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
    local t = {}
    for i=1, #hand do
      if hand[i]:get_id() > 10 and hand[i]:get_id() < 14 then contains_face = true; t[#t+1] = hand[i] end
      if hand[i]:get_id() == 14 then contains_ace = true; t[#t+1] = hand[i] end
    end
    if contains_face and contains_ace and next(get_straight(hand, nil, true, true)) then
      table.insert(ret, t)
      return ret
    end
    for j = 1, #suits do
      local t = {}
      local suit = suits[j]
      local flush_count = 0
      for i=1, #hand do
        if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1;  t[#t+1] = hand[i] end 
      end
      if flush_count >= (5 - (four_fingers and 1 or 0)) then
        table.insert(ret, t)
        return ret
      end
    end
    return {}
  end
end
-- royaling rn

local get_poker_hand_info_ref = G.FUNCS.get_poker_hand_info

function G.FUNCS.get_poker_hand_info(_cards)
    if not next(SMODS.find_card("j_cracker_royaldecree")) then return get_poker_hand_info_ref(_cards) end
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text, disp_text, loc_disp_text = 'NULL', 'NULL', 'NULL'
    for _, v in ipairs(G.handlist) do
        if next(poker_hands[v]) then
            text = v
            scoring_hand = poker_hands[v][1]
            break
        end
    end
    disp_text = text
    local _hand = SMODS.PokerHands[text]
    if text == 'Straight Flush' then
        local contains_face = false
        local contains_ace = false
        for j = 1, #scoring_hand do
            local rank = SMODS.Ranks[scoring_hand[j].base.value]
            contains_ace = contains_ace or rank.key == 'Ace'
            contains_face = contains_face or rank.key == 'Jack' or rank.key == 'Queen' or rank.key == 'King'
        end
        if contains_ace and contains_face then
            disp_text = 'Royal Flush'
        end
    elseif _hand and _hand.modify_display_text and type(_hand.modify_display_text) == 'function' then
        disp_text = _hand:modify_display_text(_cards, scoring_hand) or disp_text
    end
    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end