-- main `S` code in init.lua
local S
S = farming_plus.S

----

minetest.register_node("farming_plus:cherry_sapling", {
	description = S("Cherry Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"farming_plus_cherry_sapling.png"},
	inventory_image = "farming_plus_cherry_sapling.png",
	wield_image = "farming_plus_cherry_sapling.png",
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

local cherry_tree = table.copy(minetest.registered_nodes["default:tree"])
cherry_tree.description = "Cherry Tree"
cherry_tree.drop = "default:tree"
minetest.register_node("farming_plus:cherry_tree", cherry_tree)

minetest.register_node("farming_plus:cherry_leaves", {
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {'farming_plus:cherry_sapling'},
				rarity = 20,
			},
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("farming_plus:cherry", {
	description = S("Cherry"),
	tiles = {"farming_plus_cherry.png"},
	inventory_image = "farming_plus_cherry.png",
	wield_image = "farming_plus_cherry.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	sounds = default.node_sound_defaults(),
	on_use = minetest.item_eat(2),
})

minetest.register_abm({
	nodenames = {"farming_plus:cherry_sapling"},
	interval = 60,
	chance = 20,
	catch_up = true,
	action = function(pos, node)
		if minetest.get_node_light(pos) < 13 then
			return
		end
		minetest.log("action", "A cherry sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		farming_plus.generate_tree(pos, "farming_plus:cherry_tree", "farming_plus:cherry_leaves", {"default:dirt", "default:dirt_with_grass"}, {["farming_plus:cherry"]=20})
	end
})

default.register_leafdecay({
	trunks = {"farming_plus:cherry_tree"},
	leaves = {"farming_plus:cherry_leaves", "farming_plus:cherry"},
	radius = 2,
})

farming_plus.add_tree("cherry",
	function(minp, maxp, blockseed)
		local tmp = {x=(maxp.x-minp.x)/2+minp.x, y=(maxp.y-minp.y)/2+minp.y, z=(maxp.z-minp.z)/2+minp.z}

		-- See corresponding function in 'bananas.lua'
		local forest = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:tree"})
		if forest == nil then
			return nil
		end

		local node = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:dirt_with_grass"})
		if node == nil then
			return nil
		end
		local pos = {x=node.x, y=node.y+1, z=node.z}
		farming_plus.generate_tree(pos, "farming_plus:cherry_tree", "farming_plus:cherry_leaves",  {"default:dirt", "default:dirt_with_grass"}, {["farming_plus:cherry"]=10})
		return pos
	end,
	3
)
