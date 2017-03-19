-- main `S` code in init.lua
local S
S = farming_plus.S

minetest.register_node("farming_plus:cocoa_sapling", {
	description = S("Cocoa Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"farming_plus_cocoa_sapling.png"},
	inventory_image = "farming_plus_cocoa_sapling.png",
	wield_image = "farming_plus_cocoa_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate=3, flammable=2, attached_node = 1,
		sapling = 1},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("farming_plus:cocoa_leaves", {
	drawtype = "allfaces_optional",
	tiles = {"farming_plus_banana_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, not_in_creative_inventory=1},
 	drop = {
		max_items = 1,
		items = {
			{
				items = {'farming_plus:cocoa_sapling'},
				rarity = 20,
			},
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_abm({
	nodenames = {"farming_plus:cocoa_sapling"},
	interval = 60,
	chance = 20,
	catch_up = true,
	action = function(pos, node)
		if minetest.get_node_light(pos) < 13 then
			return
		end
		minetest.log("action", "A cocoa sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		farming_plus.generate_tree(pos, "default:tree", "farming_plus:cocoa_leaves", {"default:dirt", "default:dirt_with_grass"}, {["farming_plus:cocoa"]=20})
	end
})

minetest.register_on_generated(function(minp, maxp, blockseed)
	if math.random(1, 100) > 17 then
		return
	end
	local tmp = {x=(maxp.x-minp.x)/2+minp.x, y=(maxp.y-minp.y)/2+minp.y, z=(maxp.z-minp.z)/2+minp.z}

	-- See corresponding function in 'bananas.ini'.
	local jungle = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:jungletree"})
	if jungle == nil then
		return
	end

	local pos = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:dirt_with_grass"})
	if pos ~= nil then
		farming_plus.generate_tree({x=pos.x, y=pos.y+1, z=pos.z}, "default:tree", "farming_plus:cocoa_leaves", {"default:dirt", "default:dirt_with_grass"}, {["farming_plus:cocoa"]=20})
	end
end)

minetest.register_node("farming_plus:cocoa", {
	description = S("Cocoa"),
	tiles = {"farming_plus_cocoa.png"},
	visual_scale = 0.5,
	inventory_image = "farming_plus_cocoa.png",
	wield_image = "farming_plus_cocoa.png",
	drawtype = "torchlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_craftitem("farming_plus:cocoa_bean", {
	description = "Cocoa Bean",
	inventory_image = "farming_plus_cocoa_bean.png",
})

minetest.register_craft({
	output = "farming_plus:cocoa_bean 10",
	type = "shapeless",
	recipe = {"farming_plus:cocoa"},
})
