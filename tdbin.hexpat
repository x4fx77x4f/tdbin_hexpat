#pragma endian little
#include <std/mem.pat>
#include <std/io.pat>
#include <std/sys.pat>
u24 tdbin_version = 0;
struct vec_t {
	float x;
	float y;
	float z;
} [[static, format("vec_str")]];
fn vec_str(vec_t vec) {
	return std::format("Vec({:.3g}, {:.3g}, {:.3g})", vec.x, vec.y, vec.z);
};
struct quat_t {
	float x;
	float y;
	float z;
	float w;
} [[static, format("quat_str")]];
fn quat_str(quat_t quat) {
	return std::format("Quat({:.3g}, {:.3g}, {:.3g}, {:.3g})", quat.x, quat.y, quat.z, quat.w);
};
struct transform_t {
	vec_t pos;
	quat_t rot;
} [[static, format("transform_str")]];
fn transform_str(transform_t transform) {
	return std::format("Transform({:s}, {:s})", vec_str(transform.pos), quat_str(transform.rot));
};
using entity_handle_t = u32;
using postprocessing_t;
using player_t;
using environment_t;
using boundary_t;
using fire_t;
using palette_t;
using pair_t;
using entity_t;
struct tdbin_t {
	if (std::mem::read_string($, 5) == "TDBIN") {
		char magic[5];
		be u24 version;
		tdbin_version = version;
		if (tdbin_version >= 0x000501) {
			char level[];
		}
		entity_handle_t driven_vehicle;
	} else {
		tdbin_version = 0x000300; // 0.3.0 (perftest)
		float unknown_4; // could this be driven_vehicle?
	}
	std::print("TDBIN {:d}.{:d}.{:d}", (tdbin_version & 0xff0000) >> 16, (tdbin_version & 0xff00) >> 8, tdbin_version & 0xff);
	vec_t shadow_volume;
	transform_t spawnpoint;
	if (tdbin_version >= 0x000501) {
		entity_handle_t world_body;
		entity_handle_t flashlight;
	}
	if (tdbin_version >= 0x000700) {
		entity_handle_t explosion_script;
	}
	if (tdbin_version >= 0x010100) {
		entity_handle_t achievement_script;
	}
	if (tdbin_version >= 0x000700) {
		postprocessing_t postprocessing;
	}
	player_t player;
	environment_t environment;
	boundary_t boundary;
	u32 fire_count;
	fire_t fires[fire_count];
	u32 palette_count;
	palette_t palettes[palette_count];
	u32 pair_count;
	pair_t registry[pair_count];
	u32 entity_count;
	entity_t entities[entity_count];
	//std::assert($ == std::mem::size(), "bad tdbin");
};
struct postprocessing_t {
	float brightness;
	float colorbalance_r;
	float colorbalance_g;
	float colorbalance_b;
	float colorbalance_a;
	float saturation;
	float gamma;
	if (tdbin_version >= 0x000800) {
		float bloom;
	}
};
struct player_t {
	transform_t transform;
	float yaw;
	float pitch;
	vec_t velocity;
	float health;
	float unknown_1;
	float bluetide; // this variable predates bluetide tho
	if (tdbin_version >= 0x000900) {
		float unknown_2;
		float unknown_3;
	}
};
struct environment_t {
	char skybox[];
	float skybox_tint_r;
	float skybox_tint_g;
	float skybox_tint_b;
	float skybox_tint_a;
	if (tdbin_version >= 0x000800) {
		float brightness;
	}
	float skybox_rot;
	float sun_tint_brightness_r;
	float sun_tint_brightness_g;
	float sun_tint_brightness_b;
	float sun_color_tint_r;
	float sun_color_tint_g;
	float sun_color_tint_b;
	float sun_color_tint_a;
	vec_t sun_dir;
	float sun_brightness;
	if (tdbin_version <= 0x000300) {
		u8 unknown_5;
	}
	float sun_spread;
	float sun_length;
	float sun_fog_scale;
	float sun_glare;
	if (tdbin_version > 0x000300) {
		u8 unknown_6;
	}
	if (tdbin_version >= 0x000700) {
		float constant_r;
		float constant_g;
		float constant_b;
		float constant_a;
	}
	float ambient;
	if (tdbin_version >= 0x000700) {
		float ambient_exponent;
	}
	float exposure_min;
	float exposure_max;
	float brightness;
	if (tdbin_version > 0x000300) {
		float fog_color_r;
		float fog_color_g;
		float fog_color_b;
		float fog_color_a;
	}
	float fog_start;
	float fog_distance;
	float fog_amount;
	float fog_exponent;
	float water_wetness;
	float water_puddleamount;
	float water_puddlesize;
	float water_rain;
	u8 nightlight;
	char ambience_path[];
	float ambience_volume;
	if (tdbin_version >= 0x000505) {
		float slippery;
	}
	if (tdbin_version >= 0x000700) {
		float fog_scale;
	}
	if (tdbin_version >= 0x000900) {
		vec_t snow_dir;
		float snow_spread;
		float snow_amount;
		float snow_speed;
		u8 snow_ground;
		vec_t wind;
		float water_hurt;
	}
	if (tdbin_version >= 0x000701 && tdbin_version < 0x000900) {
		u32 unknown_7[8];
		u8 unknown_8;
	}
};
using boundary_vertex_t;
struct boundary_t {
	u32 vertex_count;
	boundary_vertex_t vertices[vertex_count];
	if (tdbin_version >= 0x000900) {
		float pad_left;
		float pad_top;
		float pad_right;
		float pad_bottom;
	}
};
struct boundary_vertex_t {
	float x;
	float z;
} [[static, format("boundary_vertex_str")]];
fn boundary_vertex_str(boundary_vertex_t vertex) {
	return std::format("{:.3g} {:.3g}", vertex.x, vertex.z);
};
struct fire_t {
	entity_handle_t entity;
	vec_t pos;
	float max_time;
	float time;
	u8 unknown_9[6];
} [[static]];
using palette_material_t;
struct palette_t {
	palette_material_t materials[256];
	u8 unknown_10;
	u8 tint_black[4*256];
	u8 tint_yellow[4*256];
} [[static]];
struct palette_material_t {
	u8 kind;
	float r;
	float g;
	float b;
	float a;
	float reflectivity;
	float shininess;
	float metalness;
	float emissive;
	u8 replaceable;
} [[static]];
struct pair_t {
	char key[];
	char value[];
} [[format("pair_str")]];
fn pair_str(pair_t node) {
	return std::format("[\"{:s}\"]=\"{:s}\",", node.key, node.value);
};
enum entity_type_t : u8 {
	body = 0x01,
	shape,
	light,
	location,
	water,
	enemy,
	joint,
	vehicle,
	wheel,
	screen,
	trigger,
	script,
};
using entity_body_t;
using entity_shape_t;
using entity_light_t;
using entity_location_t;
using entity_water_t;
using entity_enemy_t;
using entity_joint_t;
using entity_vehicle_t;
using entity_wheel_t;
using entity_screen_t;
using entity_trigger_t;
using entity_script_t;
struct entity_t {
	u8 type_raw;
	u8 type = type_raw;
	if (tdbin_version >= 0x000906 && type >= entity_type_t::enemy) {
		type += 1;
	}
	entity_handle_t handle;
	u8 tag_count;
	pair_t tags[tag_count];
	char description[];
	match (type) {
		(entity_type_t::body): entity_body_t entity;
		(entity_type_t::shape): entity_shape_t entity;
		(entity_type_t::light): entity_light_t entity;
		(entity_type_t::location): entity_location_t entity;
		(entity_type_t::water): entity_water_t entity;
		(entity_type_t::enemy): entity_enemy_t entity;
		(entity_type_t::joint): entity_joint_t entity;
		(entity_type_t::vehicle): entity_vehicle_t entity;
		(entity_type_t::wheel): entity_wheel_t entity;
		(entity_type_t::screen): entity_screen_t entity;
		(entity_type_t::trigger): entity_trigger_t entity;
		(entity_type_t::script): entity_script_t entity;
	}
	u32 pad;
	std::assert(pad == 0xbeefbeef, "bad entity pad");
};
struct entity_body_t {
	std::error("entity type body not implemented");
};
struct entity_shape_t {
	std::error("entity type shape not implemented");
};
struct entity_light_t {
	std::error("entity type light not implemented");
};
struct entity_location_t {
	std::error("entity type location not implemented");
};
struct entity_water_t {
	std::error("entity type water not implemented");
};
struct entity_enemy_t {
	std::error("entity type enemy not implemented");
};
struct entity_joint_t {
	std::error("entity type joint not implemented");
};
struct entity_vehicle_t {
	std::error("entity type vehicle not implemented");
};
struct entity_wheel_t {
	std::error("entity type wheel not implemented");
};
struct entity_screen_t {
	std::error("entity type screen not implemented");
};
struct entity_trigger_t {
	std::error("entity type trigger not implemented");
};
struct entity_screen_t {
	std::error("entity type screen not implemented");
};
tdbin_t tdbin @ 0;
