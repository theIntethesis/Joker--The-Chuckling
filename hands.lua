JTC.WUBRG_Straight = SMODS.PokerHand {
    key = '5cStraight',
    name = 'WUBRG Straight',
    mult = 5,
    chips = 50,
    l_mult = 4, 
    l_chips = 50,
    evaluate = function(parts, hand)
        if not next(parts.JTC_WUBRG) or not next(parts._straight) then return {} end
        return {SMODS.merge_lists(parts.JTC_WUBRG, parts._straight)}
    end,
    loc_txt = {
        description = {
            name = 'WUBRG Straight',
            disp_text = 'WUBRG Straight'
        }
    },
    example = {
        {'JTC_W_A', true},
        {'JTC_U_5', true},
        {'JTC_B_4', true},
        {'JTC_R_3', true},
        {'JTC_G_2', true}
    },
}

JTC.WUBRG = SMODS.PokerHandPart {
    key = 'WUBRG',
    func = function(hand)
        local suits = {}
        for _, v in ipairs(SMODS.Suit.obj_buffer) do
            suits[v] = 0
        end
        if #hand < 5 then return {} end
        for i = 1, #hand do
            if not SMODS.has_any_suit(hand[i]) then
                for k, v in pairs(suits) do
                    if hand[i]:is_suit(k, nil, true) and v == 0 then
                        suits[k] = v + 1; break
                    end
                end
            end
        end
        local num_suits = 0
        for _,v in pairs(suits) do
            if v > 0 then num_suits = num_suits + 1 end
        end
        return (num_suits >= 5) and {hand} or {}
    end
}