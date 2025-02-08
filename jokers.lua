--[[SMODS.Atlas {
    key = 'GrixisJoker',
    path = 'Grixis.png',
    px = 71,
    py = 95
}]]

SMODS.Atlas {
    key = 'JundJoker',
    path = 'Jund.png',
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'jund',
    rarity = 2,
    atlas = 'JundJoker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            mult = 0,
            mult_gain = 2,
        }
    },
    loc_txt = {
        name = "Jund",
        text = {
            "MANA: ONLY Black, Red, Green",
            "CARDS SCORED: 5",
            "Destroy all White and Blue",
            "cards held in hand and gain ",
            "{C:mult}+#2#{} Mult per card destroyed.",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_gain
            }
        }
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        local jundHand = true
        if context.cardarea == G.play and #context.scoring_hand ~= 5 then jundHand = false end
        if jundHand and context.cardarea == G.play then
            for _, p in ipairs(context.scoring_hand) do
                if p:is_suit("JTC_White") or p:is_suit("JTC_Blue") then
                    jundHand = false
                end
            end
        end
        if context.before and jundHand and not (context.individual or context.repetition) then
            local UWCards = {}
            for _, handCard in ipairs(G.hand.cards) do
                if handCard:is_suit("JTC_White") or handCard:is_suit("JTC_Blue") then
                    UWCards[#UWCards+1] = handCard
                end
            end
            if #UWCards > 0 then
                card.ability.extra.mult = card.ability.extra.mult + ((card.ability.extra.mult_gain or 2) * #UWCards)
                JTC_UTIL.destroy_playing_cards(UWCards, card, {
                    message = 'Junded',
                    colour = G.C.MULT
                })
                UWCards = {}
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end 
}

SMODS.Atlas{
    key = 'OrzhovJoker',
    path = 'Orzhov.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'orzhov',
    rarity = 1,
    atlas = 'OrzhovJoker',
    pos = {x=0, y=0},
    config = {
        extra = {
            money = 0,
            money_gain = 1
        }
    },
    loc_txt = {
        name = 'Orzhov Syndicate',
        text = {
            'MANA: White, Black',
            'Gains {C:money}+$#2#{}',
            '{C:inactive}(Currently {C:money}+$#1#{C:inactive} at end of round){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money,
                card.ability.extra.money_gain
            }
        }
    end,
    cost = 4,
    unlocked = true,
    discovered = true,
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then return bonus end
    end,
    calculate = function(self, card, context)
        if context.before and JTC_UTIL.hand_has_colors(context.scoring_hand, card, {
            white = false, 
            blue = true, 
            black = false, 
            red = true, 
            green = true
        }) then
            card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain
            return {
                message = 'Coin in the Coffer!',
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

SMODS.Atlas{
    key = 'RakdosJoker',
    path = 'Rakdos.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'rakdos',
    rarity = 1,
    atlas = 'RakdosJoker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            chips = 0,
            mult = 0
        }
    },
    loc_txt = {
        name = "Cult of Rakdos",
        text = {
            'MANA: Black, Red',
            'Gains {C:chips}chips{} equal to',
            'the sum of the Black cards scored.',
            'Gains {C:mult}mult{} equal to',
            'the number of Red cards scored.',
            '{C:inactive}(Currently {C:chips}+#1#{},  {C:mult}+#2#{C:inactive})'
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,
    cost = 4,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.before and JTC_UTIL.hand_has_colors(context.scoring_hand, card, {
            white = true, blue = true, black = false, red = false, green = true
        }) then
            local blackSum = 0
            local redNum = 0
            for _, c in ipairs(context.scoring_hand) do
                if c:is_suit("JTC_Black") then blackSum = blackSum + c.base.nominal 
                    sendInfoMessage("Chips: "..c.base.nominal, "MyInfoLogger") end
                if c:is_suit("JTC_Red") then redNum = redNum + 1 end
            end
            card.ability.extra.chips = card.ability.extra.chips + blackSum
            card.ability.extra.mult = card.ability.extra.mult + redNum
            return {
                message = 'Rakdos!',
                colour = G.C.IMPORTANT,
                card = card
            }
        end
        if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				mult = card.ability.extra.chips,
                card = card
			}
		end
    end
}

--[[
SMODS.Atlas{
    key = '',
    path = '.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = '',
    rarity = 2,
    atlas = '',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            
        }
    },
    loc_txt = {
        name = "",
        text = {
            
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                
            }
        }
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        
    end
}]]