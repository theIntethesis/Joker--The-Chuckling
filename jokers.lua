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
            spell = true
        }
    },
    loc_txt = {
        name = "Jund",
        text = {
            "MANA: {2}, Black, Red, Green",
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
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Spell', G.C.PURPLE, G.C.BLACK)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.before and JTC_UTIL.hand_has_colors(context.scoring_hand, card, {
            white = true,
            blue = true,
            black = false,
            red = false,
            green = false
        }) and not (context.individual or context.repetition) and #context.scoring_hand == 5 then
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
    rarity = 2,
    atlas = 'OrzhovJoker',
    pos = {x=0, y=0},
    config = {
        extra = {
            money = 0,
            money_gain = 1,
            boss_beaten = false,
            spell = true
        }
    },
    loc_txt = {
        name = 'Orzhov Tithes',
        text = {
            'MANA: White, Black',
            'Gains {C:money}+$#2#{}',
            'Resets at start of {C:important}ante',
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
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Spell', G.C.PURPLE, G.C.BLACK)
    end,
    cost = 4,
    unlocked = true,
    discovered = true,
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then return bonus end
    end,
    calculate = function(self, card, context)
        if context.before then
            if JTC_UTIL.hand_has_colors(context.scoring_hand, card, {
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
                    card = card,
                    spell_effect = true
                }
            end
        end
        
        if context.end_of_round and not context.blueprint and G.GAME.blind.boss and context.cardarea == G.jokers then
            card.ability.extra.boss_beaten = true
        end

        if context.ending_shop and card.ability.extra.boss_beaten then
            card.ability.extra.money = 0
            card.ability.extra.boss_beaten = false
            return {
                message = 'Reset!',
                color = G.C.MONEY,
                card = card,
                spell_effect = false
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
            mult = 0,
            spell = true
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

SMODS.Atlas{
    key = 'krarks_thumb_joker',
    path = 'krarks_thumb.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "krarks_thumb",
    rarity = 2,
    atlas = 'krarks_thumb_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            odds = 2,
            repetitions = 1,
            artifact = 1
        }
    },
    loc_txt = {
        name = "Krark's Thumb",
        text = {
            "Played cards have a",
            "{C:green}#1# in #2#{} chance to retrigger"
        }
    },
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.probabilities.normal,
                card.ability.extra.odds
            }
        }
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if pseudorandom('krarks_thumb') < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                return {
                    message = 'Heads!',
                    repetitions = card.ability.extra.repetitions, 
                    card = context.other_card
                }
            end
        end
    end
}

SMODS.Atlas{
    key = 'ashnods_altar_joker',
    path = 'ashnods_altar.png',
    px = 71,
    py = 95
}

JTC.Joker{
    key = "ashnods_altar",
    rarity = 2,
    atlas = 'ashnods_altar_joker',
    cardType = "Artifact",
    pos = {x = 0, y = 0},
    config = {
        extra = {
            
        }
    },
    loc_txt = {
        name = "Ashnod's Altar",
        text = {
            "If {C:attention}first hand{} of round has only {C:attention}1{} card,",
            "destroy it and add a {C:grey}Colorless{} card",
            "to your deck and draw it to {C:attention}hand",
        }
    },
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                
            }
        }
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.hands_played == 0 then
            if #context.full_hand == 1 then
                SMODS.create_card({
                    set = 'Enhanced',
                    area = G.hand,
                    no_edition = true,
                    enhancement = 'Stone'
                })
                --[[G.E_MANAGER:add_event(Event({
                    func = function()
                        local new_card = create_playing_card({
                            front = {
                                name = 'JTC_White_Ace',
                                suit = "JTC_White",
                                value = 'A',
                                nominal = 11
                            },
                            center = JTC_m_Colorless
                        }, G.hand, true)
                        assert(SMODS.change_base(new_card, "JTC_White", 'Ace'))
                        return true
                    end
                }))]]
                
                JTC_UTIL.destroy_playing_cards({context.full_hand[1]}, card, {
                    message = 'Sacrificed!',
                    colour = G.C.GREY
                })
            end
        end
    end
}


SMODS.Atlas{
    key = 'plains_joker',
    path = 'plains.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'plains',
    rarity = 1,
    atlas = 'plains_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            suit_mult = 3,
            suit = 'JTC_White'
        }
    },
    loc_txt = {
        name = "Plains",
        text = {
            "White cards give {C:mult}+#1#{}",
            "mult when scored"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.suit_mult
            }
        }
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play then
            sendDebugMessage("Checking suit: "--[[..card.base.suit]], "MyDebugLogger")
            if(context.other_card:is_suit("JTC_White")) then
                return {
                    message = '+'..self.config.extra.suit_mult,
                    colour = G.C.MULT,
                    mult = self.config.extra.suit_mult,
                    card = context.other_card
                }
            end
        end
    end
}

SMODS.Atlas{
    key = 'tamiyos_journal_joker',
    path = 'tamiyos_journal.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'tamiyos_journal',
    rarity = 2,
    atlas = 'tamiyos_journal_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            artifact = true
        }
    },
    loc_txt = {
        name = "Tamiyo's Journal",
        text = {
            "Create a Clue consumable",
            "when blind is selected",
            "{C:inactive}(You must have room){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.setting_blind and not self.getting_sliced and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card('JTC_Token',G.consumeables, nil, nil, nil, nil, "c_JTC_clue", nil)
                            card:add_to_deck()
                            card:set_edition({negative = true})
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
        end
    end
}

SMODS.Atlas{
    key = 'lightning_bolt_joker',
    path = 'lightning_bolt.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'lightning_bolt',
    rarity = 1,
    atlas = 'lightning_bolt_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            mult = 3,
            mana_table = {
                white = 0,
                blue = 0,
                black = 0,
                red = 0,
                green = 0,
                generic = 0
            },
            spell = true
        }
    },
    loc_txt = {
        name = "Lightning Bolt",
        text = {
            "Mana: R",
            "{C:mult}+#1#{} mult",
            "Repeatable"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.mult
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Spell', G.C.PURPLE, G.C.BLACK)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.repetition then
            if mana_table.generic == 0 then 
                mana_table = JTC_UTIL.get_mana_table(context.scoring_hand)
            end
            if mana_table.red > 1 then
                mana_table.red = mana_table.red - 1
                card.ability.extra.mana_table = mana_table
                return{
                    card = card,
                    repetitions = 1,
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

SMODS.Atlas{
    key = 'esper_joker',
    path = 'esper.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'esper',
    rarity = 2,
    atlas = 'esper_joker',
    pos = {x = 0, y = 0},
    card_type = "Artifact",
    config = {
        extra = {
            mult = 1,
            artifact = 1,
            faction = true
        }
    },
    loc_txt = {
        name = "Esper Automa",
        text = {
            "Artifacts you have give",
            "{C:mult}+#1#{} mult for each",
            "Artifact you have.",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} mult)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.mult,
                JTC_UTIL.get_number_of_artifacts()
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
        badges[#badges+1] = create_badge('Faction', G.C.GREEN, G.C.BLACK)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.other_joker and self ~= context.other_joker then
            if type(context.other_joker.ability.extra) == "table" and context.other_joker.ability.extra.artifact then 
                return {
                    colour = G.C.MULT,
                    card = context.other_joker,
                    mult = JTC_UTIL.get_number_of_artifacts()
                }
            end
        end
        if context.other_consumeable then
            if type(context.other_consumeable.ability.extra) == "table" and context.other_consumeable.ability.extra.artifact then 
                return {
                    colour = G.C.MULT,
                    card = context.other_consumeable,
                    mult = JTC_UTIL.get_number_of_artifacts()
                }
            end
        end
    end
}


SMODS.Atlas{
    key = 'kaldra_helm_joker',
    path = 'kaldra_helm.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'kaldra_helm',
    rarity = 1,
    atlas = 'kaldra_helm_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            artifact = 1,
            chips = 30
        }
    },
    loc_txt = {
        name = "Helm of Kaldra",
        text = {
            "{C:chips}+#1#{} chips"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.chips
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    add_to_deck = function(self, card, from_debuff)
        if SMODS.find_card("j_JTC_kaldra_sword") and SMODS.find_card("j_JTC_kaldra_helm") and SMODS.find_card("j_JTC_kaldra_shield") then
            -- Delete all three and add kaldra_avatar
            for j = #G.jokers.cards, 1, -1 do
                if G.jokers.cards[j].config.center.name == "j_JTC_kaldra_sword" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_helm" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_shield" then
                    JTC_UTIL.destroy_joker(G.jokers.cards[j])
                end
            end

            JTC_UTIL.destroy_joker(card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                func = (function()
                        local card = create_card('Joker',G.jokers, nil, nil, nil, nil, "j_JTC_kaldra_avatar", nil)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                    return true
                end)
            }))
        end
    end,
    cost = 3,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}


SMODS.Atlas{
    key = 'kaldra_sword_joker',
    path = 'kaldra_sword.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'kaldra_sword',
    rarity = 1,
    atlas = 'kaldra_sword_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            mult = 4,
            artifact = true
        }
    },
    loc_txt = {
        name = "Sword of Kaldra",
        text = {
            "{C:mult}+#1#{} mult"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.mult
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    add_to_deck = function(self, card, from_debuff)
        if SMODS.find_card("j_JTC_kaldra_sword") and SMODS.find_card("j_JTC_kaldra_helm") and SMODS.find_card("j_JTC_kaldra_shield") then
            -- Delete all three and add kaldra_avatar
            for j = #G.jokers.cards, 1, -1 do
                if G.jokers.cards[j].config.center.name == "j_JTC_kaldra_sword" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_helm" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_shield" then
                    JTC_UTIL.destroy_joker(G.jokers.cards[j])
                end
            end

            JTC_UTIL.destroy_joker(card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                func = (function()
                        local card = create_card('Joker',G.jokers, nil, nil, nil, nil, "j_JTC_kaldra_avatar", nil)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                    return true
                end)
            }))
        end
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}


SMODS.Atlas{
    key = 'kaldra_shield_joker',
    path = 'kaldra_shield.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'kaldra_shield',
    rarity = 2,
    atlas = 'kaldra_shield_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            xmult = 1.5,
            artifact = 1
        }
    },
    loc_txt = {
        name = "Shield of Kaldra",
        text = {
            "{X:mult,C:white}x#1#{} mult",
            "If you have the Helm, Sword, and Shield of Kaldra,",
            "exile them, then return them melded."
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.xmult
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    add_to_deck = function(self, card, from_debuff)
        if SMODS.find_card("j_JTC_kaldra_sword") and SMODS.find_card("j_JTC_kaldra_helm") and SMODS.find_card("j_JTC_kaldra_shield") then
            -- Delete all three and add kaldra_avatar
            for j = #G.jokers.cards, 1, -1 do
                if G.jokers.cards[j].config.center.name == "j_JTC_kaldra_sword" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_helm" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_shield" then
                    JTC_UTIL.destroy_joker(G.jokers.cards[j])
                end
            end

            JTC_UTIL.destroy_joker(card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                func = (function()
                        local card = create_card('Joker',G.jokers, nil, nil, nil, nil, "j_JTC_kaldra_avatar", nil)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                    return true
                end)
            }))
        end
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Atlas{
    key = 'kaldra_avatar_joker',
    path = 'kaldra_avatar.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'kaldra_avatar',
    rarity = 4,
    atlas = 'kaldra_avatar_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            xmult = 3,
            xchips = 3,
            artifact = 3,
            joker_slots = -2
        }
    },
    loc_txt = {
        name = "Kaldra, Mirran Triad",
        text = {
            "{X:mult,C:white}x#1#{} mult",
            "{X:chips,C:white}x#2#{} chips",
            "{C:gold}#3#{} jokers",
            "Counts as three Artifacts"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.xchips,
                card.ability.extra.joker_slots
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - 2

        if (SMODS.find_card("j_JTC_kaldra_sword") and SMODS.find_card("j_JTC_kaldra_helm") and SMODS.find_card("j_JTC_kaldra_shield")) or SMODS.find_card("j_JTC_kaldra_avatar") then
            -- Delete all three and add kaldra_avatar
            for j = #G.jokers.cards, 1, -1 do
                if G.jokers.cards[j].config.center.name == "j_JTC_kaldra_sword" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_helm" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_shield" or G.jokers.cards[j].config.center.name == "j_JTC_kaldra_avatar" then
                    JTC_UTIL.destroy_joker(G.jokers.cards[j])
                end
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 2
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = JTC_UTIL.get_xchips(context.scoring_hand, card.ability.extra.xchips),
                xmult = card.ability.extra.xmult
            }
        end
    end
}


SMODS.Atlas{
    key = 'gatewatch_joker',
    path = 'gatewatch.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'gatewatch',
    rarity = 3,
    atlas = 'gatewatch_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            faction = true,
            xmult = 1.5
        }
    },
    loc_txt = {
        name = "The Gatewatch",
        text = {
            "{C:pale_green}Faction{} jokers each give",
            "{X:mult,C:white}x#1#{} Mult"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.xmult
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Faction', G.C.PALE_GREEN, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.other_joker then
            if type(context.other_joker.ability.extra) == "table" and context.other_joker.ability.extra.faction then 
                return {
                    colour = G.C.MULT,
                    card = context.other_joker,
                    xmult = self.config.extra.xmult
                }
            end
        end
    end
}

SMODS.Atlas{
    key = 'jeskai_joker',
    path = 'jeskai.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'jeskai',
    rarity = 2,
    atlas = 'jeskai_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            chips = 0,
            chips_gain = 10,
            mult = 0,
            mult_gain = 1,
            faction = true
        }
    },
    loc_txt = {
        name = "The Jeskai Way",
        text = {
            "Gains {C:chips}+#1#{} Chips and",
            "{C:mult}+#2#{} Mult this round",
            "whenever a consumable is used",
            "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips{}, {C:mult}+#4#{C:inactive} Mult)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.chips_gain,
                card.ability.extra.mult_gain,
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Faction', G.C.PALE_GREEN, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.using_consumeable then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            card = card
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
        if context.end_of_round then
            card.ability.extra.chips = 0
            card.ability.extra.mult = 0
            card = card
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}


SMODS.Atlas{
    key = 'sultai_joker',
    path = 'sultai.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'sultai',
    rarity = 2,
    atlas = 'sultai_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            chips = 10
        }
    },
    loc_txt = {
        name = "The Sultai Brood",
        text = {
            "Discarded {C:black}Black{}, {C:green}Green{}, and {C:blue}Blue",
            "cards gain {C:chips}+#1#{} chips permanently"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.chips
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Faction', G.C.PALE_GREEN, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and (context.other_card:is_suit("JTC_Green") or context.other_card:is_suit("JTC_Blue") or context.other_card:is_suit("JTC_Black")) then
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.config.extra.chips
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = context.other_card
            }
        end
    end
}

SMODS.Atlas{
    key = 'bant_joker',
    path = 'bant.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'bant',
    rarity = 2,
    atlas = 'bant_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            xmult = 2,
            xchips = 2,
            spell = true
        }
    },
    loc_txt = {
        name = "Bant Exaltation",
        text = {
            "MANA: W / U / G",
            "If played hand is a single card",
            "{X:chips,C:white}x#1#{} Chips and {X:mult,C:white}x#2#{} Mult"
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                card.ability.extra.xchips,
                card.ability.extra.xmult
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Spell', G.C.PURPLE, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main and #context.scoring_hand == 1 and (G.play.cards[1]:is_suit("JTC_White") or G.play.cards[1]:is_suit("JTC_Blue") or G.play.cards[1]:is_suit("JTC_Green")) then
            return {
                chips = JTC_UTIL.get_xchips(context.scoring_hand, card.ability.extra.xchips),
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Atlas{
    key = 'izzet_joker',
    path = 'izzet.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'izzet',
    rarity = 3,
    atlas = 'izzet_joker',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            faction = true
        }
    },
    loc_txt = {
        name = "The Izzet League",
        text = {
            "Whenever you cast a {C:purple}spell{}",
            "{C:orange}copy{} that spell."
        }
    },
    loc_vars = function(self, info_queue, card)
        return{
            vars = {
                
            }
        }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Faction', G.C.PALE_GREEN, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        for _, j in ipairs(G.jokers.cards) do 
            if j.config.center.name ~= "j_JTC_izzet" then
                ret_table = j:calculate_joker(context)
                if ret_table and ret_table[spell_effect] and ret_table[spell_effect] == true then
                    return ret_table
                end
            end
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
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('', G.C.GREY, G.C.WHITE)
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        
    end
}]]