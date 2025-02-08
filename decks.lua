SMODS.Back {
	key = 'leyline',
	loc_txt = {
		name = "Leyline Deck",
		text = {
			"Start run with",
			"12 cards each of",
			"{C:grey)}White{}, {C:blue}Blue{}, {C:black}Black{}, {C:red}Red{},",
			"and {C:green}Green{} suit"
		}
	},
	atlas = 'LeylineBack',
	pos = {x=0,y=0},
	config = {

	},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for i = #G.playing_cards, 1, -1 do
					local card  = G.playing_cards[i]
					card:start_dissolve(nil, true)
				end
				for i = 13, 1, -1 do
					local r = ""
					if i == 1 then
						r = "Ace"
					elseif i == 11 then
						r = "Jack"
					elseif i == 12 then
						r = "Queen"
					elseif i == 13 then
						r = "King"
					else
						r = ''..i
					end
					
					local W_card = create_playing_card({
						front = {
							name = 'JTC_W_'..r,
							suit = "JTC_White",
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck, true)
					assert(SMODS.change_base(W_card, "JTC_White", r))
					
					local U_card = create_playing_card({
						front = {
							name = 'JTC_U_'..r,
							suit = "JTC_Blue",
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck, true)
					assert(SMODS.change_base(U_card, "JTC_Blue", r))
					
					local B_card = create_playing_card({
						front = {
							name = 'JTC_B_'..r,
							suit = "JTC_Black",
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck, true)
					assert(SMODS.change_base(B_card, "JTC_Black", r))
					
					local R_card = create_playing_card({
						front = {
							name = 'JTC_R_'..r,
							suit = "JTC_Red",
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck, true)
					assert(SMODS.change_base(R_card, "JTC_Red", r))
					
					local G_card = create_playing_card({
						front = {
							name = 'JTC_G_'..r,
							suit = "JTC_Green",
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck, true)
					assert(SMODS.change_base(G_card, "JTC_Green", r))
				end
				
				return true
			end
		}))
	end
}