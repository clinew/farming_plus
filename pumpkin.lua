-- main `S` code in init.lua
local S
S = farming_plus.S

minetest.register_craftitem(":farming_plus:pumpkin_seed", {
	description = S("Pumpkin Seed"),
	inventory_image = "farming_plus_pumpkin_seed.png",
	on_place = function(itemstack, placer, pointed_thing)
		return farming_plus.place_seed(itemstack, placer, pointed_thing, "farming_plus:pumpkin_1")
	end
})

minetest.register_node(":farming_plus:pumpkin_1", {
	paramtype = "light",
	sunlight_propagates = true,
	drawtype = "nodebox",
	drop = "",
	tiles = {"farming_plus_pumpkin_top.png", "farming_plus_pumpkin_top.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}
		},
	},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, not_in_creative_inventory=1, plant=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node(":farming_plus:pumpkin_2", {
	paramtype = "light",
	sunlight_propagates = true,
	drawtype = "nodebox",
	drop = "",
	tiles = {"farming_plus_pumpkin_top.png", "farming_plus_pumpkin_top.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.35, -0.5, -0.35, 0.35, 0.2, 0.35}
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.35, -0.5, -0.35, 0.35, 0.2, 0.35}
		},
	},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, not_in_creative_inventory=1, plant=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node(":farming_plus:pumpkin", {
	description = S("Pumpkin"),
	paramtype2 = "facedir",
	tiles = {"farming_plus_pumpkin_top.png", "farming_plus_pumpkin_top.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, plant=1},
	sounds = default.node_sound_wood_defaults(),
	
	on_punch = function(pos, node, puncher)
		local tool = puncher:get_wielded_item():get_name()
		if tool and string.match(tool, "sword") then
			node.name = "farming_plus:pumpkin_face"
			minetest.set_node(pos, node)
			puncher:get_inventory():add_item("main", ItemStack("farming_plus:pumpkin_seed"))
			if math.random(1, 2) == 1 then
				puncher:get_inventory():add_item("main", ItemStack("farming_plus:pumpkin_seed"))
			end
			if math.random(1, 5) == 1 then
				puncher:get_inventory():add_item("main", ItemStack("farming_plus:pumpkin_seed"))
			end
		end
	end
})

farming_plus.add_plant("farming_plus:pumpkin", {"farming_plus:pumpkin_1", "farming_plus:pumpkin_2"}, 80, 20)

minetest.register_node(":farming_plus:pumpkin_face", {
	description = S("Pumpkin Face"),
	paramtype2 = "facedir",
	tiles = {"farming_plus_pumpkin_top.png", "farming_plus_pumpkin_top.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_face.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, plant=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node(":farming_plus:pumpkin_face_light", {
	description = S("Pumpkin Face With Light"),
	paramtype2 = "facedir",
	light_source = LIGHT_MAX-2,
	tiles = {"farming_plus_pumpkin_top.png", "farming_plus_pumpkin_top.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_side.png", "farming_plus_pumpkin_face_light.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	type = "shapeless",
	output = "farming_plus:pumpkin_face_light",
	recipe = {"farming_plus:pumpkin_face", "default:torch"}
})

-- ========= BIG PUMPKIN =========
minetest.register_node(":farming_plus:big_pumpkin", {
	description = S("Big Pumpkin"),
	paramtype2 = "facedir",
	tiles = {"farming_plus_pumpkin_big_side.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-1, -0.5, -1, 1, 1.5, 1}
		}
	},
	groups = {choppy=1, oddly_breakable_by_hand=1, flammable=2},
	sounds = default.node_sound_wood_defaults(),
	
	after_place_node = function(pos, placer)
		for dx=-1,1 do
			for dy=0,1 do
				for dz=-1,1 do
					pos.x = pos.x+dx
					pos.y = pos.y+dy
					pos.z = pos.z+dz
					if dx ~= 0 or dy ~= 0 or dz ~= 0 then
						if minetest.get_node(pos).name ~= "air" then
							pos.x = pos.x-dx
							pos.y = pos.y-dy
							pos.z = pos.z-dz
							minetest.remove_node(pos)
							minetest.after(0.1, function(placer)
								local inv = placer:get_inventory()
								local index = placer:get_wield_index()
								inv:set_stack("main", index, ItemStack("farming_plus:big_pumpkin"))
							end, placer)
							return
						end
					end
					pos.x = pos.x-dx
					pos.y = pos.y-dy
					pos.z = pos.z-dz
				end
			end
		end
		for dy=0,1 do
			pos.y = pos.y+dy
			pos.z = pos.z+1
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_side", param2=2})
			pos.x = pos.x-1
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_corner", param2=2})
			pos.x = pos.x+1
			pos.z = pos.z-2
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_side", param2=0})
			pos.x = pos.x+1
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_corner", param2=0})
			pos.z = pos.z+1
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_side", param2=3})
			pos.z = pos.z+1
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_corner", param2=3})
			pos.z = pos.z-1
			pos.x = pos.x-2
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_side", param2=1})
			pos.z = pos.z-1
			minetest.set_node(pos, {name="farming_plus:big_pumpkin_corner", param2=1})
			pos.z = pos.z+1
			pos.x = pos.x+1
			pos.y = pos.y-dy
		end
		pos.y = pos.y+1
		minetest.set_node(pos, {name="farming_plus:big_pumpkin_top"})
	end,
	
	after_destruct = function(pos, oldnode)
		for dx=-1,1 do
			for dy=0,1 do
				for dz=-1,1 do
					pos.x = pos.x+dx
					pos.y = pos.y+dy
					pos.z = pos.z+dz
					local name = minetest.get_node(pos).name
					if string.find(name, "farming_plus:big_pumpkin") then
						minetest.remove_node(pos)
					end
					pos.x = pos.x-dx
					pos.y = pos.y-dy
					pos.z = pos.z-dz
				end
			end
		end
	end
})

minetest.register_node(":farming_plus:big_pumpkin_side", {
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	tiles = {"farming_plus_pumpkin_big_top_side.png", "farming_plus_pumpkin_big_side.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0.5, 0.5}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}
		}
	},
	groups = {not_in_creative_inventory=1},
})
minetest.register_node(":farming_plus:big_pumpkin_corner", {
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	tiles = {"farming_plus_pumpkin_big_top_corner.png", "farming_plus_pumpkin_big_side.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0, 0.5, 0.5}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}
		}
	},
	groups = {not_in_creative_inventory=1},
})

minetest.register_node(":farming_plus:big_pumpkin_top", {
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"farming_plus_pumpkin_big_top.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}
		}
	},
	groups = {not_in_creative_inventory=1},
})

minetest.register_craft({
	type = "shapeless",
	output = "farming_plus:big_pumpkin",
	recipe = {"bucket:bucket_water", "farming_plus:pumpkin"},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})

-- ========= SCARECROW =========
local box1 = {
	{-1, -8, -1, 1, 8, 1},
}

local box2 = {
	{-1, -8, -1, 1, 8, 1},
	{-12, -8, -1, 12, -7, 1},
	{-5, -2, -5, 5, 8, 5}
}

for j,list in ipairs(box1) do
	for i,int in ipairs(list) do
		list[i] = int/16
	end
	box1[j] = list
end

for j,list in ipairs(box2) do
	for i,int in ipairs(list) do
		list[i] = int/16
	end
	box2[j] = list
end

minetest.register_node(":farming_plus:scarecrow", {
	description = S("Scarecrow"),
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	tiles = {"farming_plus_scarecrow_top.png", "farming_plus_scarecrow_top.png", "farming_plus_scarecrow_side.png", "farming_plus_scarecrow_side.png", "farming_plus_scarecrow_side.png", "farming_plus_scarecrow_front.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = box2
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-12/16, -1.5, -0.5, 12/16, 0.5, 0.5}
		}
	},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	
	after_place_node = function(pos, placer)
		local node = minetest.get_node(pos)
		local param2 = node.param2
		pos.y = pos.y+1
		if minetest.get_node(pos).name ~= "air" then
			pos.y = pos.y-1
			minetest.remove_node(pos)
			minetest.after(0.1, function(placer)
				local inv = placer:get_inventory()
				local index = placer:get_wield_index()
				inv:set_stack("main", index, ItemStack("farming_plus:scarecrow"))
			end, placer)
			return
		end
		minetest.set_node(pos, node)
		pos.y = pos.y-1
		node.name = "farming_plus:scarecrow_bottom"
		minetest.set_node(pos, node)
	end,
	
	after_destruct = function(pos, oldnode)
		pos.y = pos.y-1
		if minetest.get_node(pos).name == "farming_plus:scarecrow_bottom" then
			minetest.remove_node(pos)
		end
	end
})

minetest.register_node(":farming_plus:scarecrow_bottom", {
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	tiles = {"default_wood.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = box1
	},
	groups = {not_in_creative_inventory=1},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}
		}
	}
})

minetest.register_craft({
	output = "farming_plus:scarecrow",
	recipe = {
		{"", "farming_plus:pumpkin_face", "",},
		{"default:stick", "default:stick", "default:stick",},
		{"", "default:stick", "",}
	}
})

minetest.register_node(":farming_plus:scarecrow_light", {
	description = S("Scarecrow With light"),
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	light_source = LIGHT_MAX-2,
	tiles = {"farming_plus_scarecrow_top.png", "farming_plus_scarecrow_top.png", "farming_plus_scarecrow_side.png", "farming_plus_scarecrow_side.png", "farming_plus_scarecrow_side.png", "farming_plus_scarecrow_front_light.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = box2
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-12/16, -1.5, -0.5, 12/16, 0.5, 0.5}
		}
	},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	
	after_place_node = function(pos, placer)
		local node = minetest.get_node(pos)
		local param2 = node.param2
		pos.y = pos.y+1
		if minetest.get_node(pos).name ~= "air" then
			pos.y = pos.y-1
			minetest.remove_node(pos)
			minetest.after(0.1, function(placer)
				local inv = placer:get_inventory()
				local index = placer:get_wield_index()
				inv:set_stack("main", index, ItemStack("farming_plus:scarecrow_light"))
			end, placer)
			return
		end
		minetest.set_node(pos, node)
		pos.y = pos.y-1
		node.name = "farming_plus:scarecrow_bottom"
		minetest.set_node(pos, node)
	end,
	
	after_destruct = function(pos, oldnode)
		pos.y = pos.y-1
		if minetest.get_node(pos).name == "farming_plus:scarecrow_bottom" then
			minetest.remove_node(pos)
		end
	end
})

minetest.register_craft({
	output = "farming_plus:scarecrow_light",
	recipe = {
		{"", "farming_plus:pumpkin_face_light", "",},
		{"default:stick", "default:stick", "default:stick",},
		{"", "default:stick", "",}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "farming_plus:scarecrow_light",
	recipe = {"farming_plus:scarecrow", "default:torch"}
})

--===============
minetest.register_craftitem(":farming_plus:pumpkin_bread", {
	description = S("Pumpkin Bread"),
	inventory_image = "farming_plus_bread_pumpkin.png",
	on_use = minetest.item_eat(8)
})

minetest.register_craftitem(":farming_plus:pumpkin_flour", {
	description = "Pumpkin Flour",
	inventory_image = "farming_plus_cake_mix_pumpkin.png",
})
minetest.register_alias("farming_plus:pumpkin_cake_mix", "farming_plus:pumpkin_flour")

minetest.register_craft({
	output = "farming_plus:pumpkin_flour",
	type = "shapeless",
	recipe = {"farming:flour", "farming_plus:pumpkin"}
})

minetest.register_craft({
	type = "cooking",
	output = "farming_plus:pumpkin_bread",
	recipe = "farming_plus:pumpkin_flour",
	cooktime = 10
})
