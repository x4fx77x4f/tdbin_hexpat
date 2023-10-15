#pragma endian little
#include <std/mem.pat>
#include <std/io.pat>
#include <std/sys.pat>
#pragma pattern_limit 500000
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
	if (tdbin_version >= 0x000500) {
		u32 unknown_22;
		u8 unknown_23[4];
		if (tdbin_version >= 0x000702) {
			u8 unknown_24[5];
		}
	}
	std::assert($ == std::mem::size(), "bad tdbin");
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
using vertex_t;
struct boundary_t {
	u32 vertex_count;
	vertex_t vertices[vertex_count];
	if (tdbin_version >= 0x000900) {
		float pad_left;
		float pad_top;
		float pad_right;
		float pad_bottom;
	}
};
struct vertex_t {
	float x;
	float z;
} [[static, format("vertex_str")]];
fn vertex_str(vertex_t vertex) {
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
	u32 child_count;
	entity_t children[child_count];
	u32 pad;
	std::assert(pad == 0xbeefbeef, "bad entity pad");
} [[format("entity_str")]];
fn entity_str(entity_t entity) {
	str type_str;
	match (entity.type_raw) {
		(entity_type_t::body): type_str = "body";
		(entity_type_t::shape): type_str = "shape";
		(entity_type_t::light): type_str = "light";
		(entity_type_t::location): type_str = "location";
		(entity_type_t::water): type_str = "water";
		(entity_type_t::enemy): type_str = "enemy";
		(entity_type_t::joint): type_str = "joint";
		(entity_type_t::vehicle): type_str = "vehicle";
		(entity_type_t::wheel): type_str = "wheel";
		(entity_type_t::screen): type_str = "screen";
		(entity_type_t::trigger): type_str = "trigger";
		(entity_type_t::script): type_str = "script";
	}
	return std::format("{:d} [{:s}]", entity.handle, type_str);
};
using entity_flags_t;
struct entity_body_t {
	entity_flags_t flags;
	transform_t transform;
	vec_t velocity;
	float angular_velocity[3];
	u8 dynamic;
	if (tdbin_version < 0x000900) {
		u8 unknown_11;
	}
	u8 body_flags;
};
struct entity_shape_t {
	entity_flags_t flags;
	transform_t transform;
	u16 shape_flags;
	u8 collision_layer;
	u8 collision_mask;
	float density;
	float strength;
	if (tdbin_version >= 0x000900) {
		u16 texture_tile;
		u16 blendtexture_tile;
		float texture_weight;
		float blendtexture_weight;
		vec_t starting_world_position; // ?
	} else {
		u32 texture_tile;
		vec_t starting_world_position; // ?
		float texture_weight;
	}
	float unknown_12;
	u8 unknown_13;
	u8 unknown_14;
	u32 sx;
	u32 sy;
	u32 sz;
	if (sx*sy*sz > 0) {
		u32 length;
		std::assert(length%2 == 0, "bad shape length");
		$ += length;
	}
	u32 palette;
	float scale;
	u32 unknown_15[2];
	if (tdbin_version >= 0x000700) {
		u8 unknown_16;
	}
};
enum entity_light_type_t : u8 {
	sphere = 0x01,
	capsule,
	cone,
	area,
};
struct entity_light_t {
	u8 enabled;
	u8 type_raw;
	u8 type = type_raw;
	if (tdbin_version < 0x000700 && type >= entity_light_type_t::capsule) {
		type += 1;
	}
	transform_t transform;
	float color_r;
	float color_g;
	float color_b;
	float color_a;
	if (tdbin_version >= 0x000500) {
		float scale;
	}
	float reach;
	float size;
	float unshadowed;
	float angle;
	float penumbra;
	float fog_iter;
	float fog_scale;
	float area_size_x;
	float area_size_z;
	if (tdbin_version >= 0x000700) {
		float capsule_size;
	}
	u8 unknown_20[13];
	float unknown_21;
	char sound_path[];
	float sound_volume;
	float glare;
};
struct entity_location_t {
	entity_flags_t flags;
	transform_t transform;
};
struct entity_water_t {
	entity_flags_t flags;
	transform_t transform;
	float depth;
	float wave;
	float ripple;
	float motion;
	float foam;
	if (tdbin_version >= 0x000900) {
		float color_r;
		float color_g;
		float color_b;
		float color_a;
	}
	if (tdbin_version >= 0x010400) {
		float visibility;
	}
	u32 vertex_count;
	vertex_t vertices[vertex_count];
};
struct entity_enemy_t {
	std::error("entity type enemy not implemented");
};
enum entity_joint_type_t : u32 {
	ball = 0x01,
	hinge,
	prismatic,
	rope,
};
using entity_joint_knot_t;
struct entity_joint_t {
	u32 type_raw;
	u32 type = type_raw;
	entity_handle_t entities[2] [[static]];
	vec_t positions[2] [[static]];
	vec_t axes[2] [[static]]; // what are these?
	u8 connected;
	u8 collide;
	float strength;
	float spring;
	quat_t rotation;
	float limit_min;
	float limit_max;
	float unknown_25;
	float unknown_26;
	float size;
	if (tdbin_version >= 0x000900) {
		u8 sound;
	}
	if (tdbin_version >= 0x000905) {
		u8 autodisable; // ?
	}
	if (tdbin_version >= 0x000900) {
		u32 unknown_27;
		u32 unknown_28;
	}
	if (type == entity_joint_type_t::rope) {
		float red;
		float green;
		float blue;
		float alpha;
		float unknown_29;
		float rope_strength;
		float max_stretch;
		float slack;
		float unknown_30;
		u8 unknown_31;
		u32 knot_count;
		entity_joint_knot_t knots[knot_count];
	}
};
struct entity_joint_knot_t { // wtf is this?
	vec_t from;
	vec_t to;
} [[static]];
using entity_vehicle_exhaust_t;
using entity_vehicle_vital_t;
struct entity_vehicle_t {
	entity_flags_t flags;
	entity_handle_t body;
	transform_t transform;
	vec_t velocity;
	vec_t angular_velocity; // TODO: euler angles type
	float unknown_32;
	u32 wheel_count;
	entity_handle_t wheels[wheel_count] [[static]];
	float top_speed;
	float unknown_33;
	float spring;
	float damping;
	float acceleration;
	float strength;
	float friction;
	float unknown_34;
	u8 handbrake;
	float antispin;
	float steerassist;
	float unknown_35;
	float antiroll;
	char sound[];
	float pitch;
	vec_t camera;
	vec_t player;
	vec_t exit;
	vec_t propeller;
	float difflock;
	float boat_sink;
	u32 voxel_count;
	if (tdbin_version > 0x000300) {
		u8 unknown_36;
		float drivable;
	}
	u32 ref_count; // wtf is this?
	u32 refs[ref_count] [[static]];
	u32 exhaust_count;
	entity_vehicle_exhaust_t exhausts[exhaust_count] [[static]];
	u32 vital_count;
	entity_vehicle_vital_t vitals[vital_count] [[static]];
	float unknown_38;
	if (tdbin_version >= 0x000900) {
		u8 unknown_39;
		float broken_threshold;
	}
};
struct entity_vehicle_exhaust_t {
	transform_t transform;
	if (tdbin_version >= 0x000700) {
		float strength;
	}
} [[static]];
struct entity_vehicle_vital_t {
	u32 body;
	vec_t pos;
	float unknown_37;
	u32 shape;
} [[static]];
struct entity_wheel_t {
	entity_flags_t flags;
	entity_handle_t vehicle;
	entity_handle_t vehicle_body;
	entity_handle_t body;
	entity_handle_t shape;
	if (tdbin_version >= 0x010300) {
		u8 unknown_40[17] [[static]];
	}
	transform_t transform;
	transform_t empty_transform; // ?
	float steer;
	float drive;
	float travel_min;
	float travel_max;
	float radius;
	float width;
	float angular_speed;
	float unknown_41;
	float unknown_42;
};
struct entity_screen_t {
	entity_flags_t flags;
	transform_t transform;
	float size_x;
	float size_y;
	float bulge;
	u32 resolution_x;
	u32 resolution_y;
	char path[];
	u8 enabled;
	u8 interactive;
	float emissive;
	float fxraster;
	float fxca;
	float fxnoise;
	float fxglitch;
};
enum entity_trigger_type_t : u32 {
	sphere = 1,
	box,
	polygon,
};
struct entity_trigger_t {
	entity_flags_t flags;
	transform_t transform;
	entity_trigger_type_t type;
	float sphere_size;
	vec_t box_size;
	float polygon_size;
	u32 vertex_count;
	vertex_t vertices[vertex_count] [[static]];
	char sound[];
	float sound_ramp;
	u8 unknown_43;
	float volume;
};
using entity_script_table_t;
using entity_script_sound_t;
using entity_script_transition_t;
struct entity_script_t {
	entity_flags_t flags;
	char path[];
	u32 parameter_count;
	pair_t parameters[parameter_count];
	float last_update;
	float time;
	u32 unknown_17;
	entity_script_table_t environment;
	if (tdbin_version < 0x000500) {
		u32 unknown_18_count;
		u32 unknown_18[unknown_18_count];
	}
	u32 handle_count;
	entity_handle_t handles[handle_count];
	u32 sound_count;
	entity_script_sound_t sounds[sound_count];
	if (tdbin_version >= 0x000704) {
		u32 transition_count;
		entity_script_transition_t transitions[transition_count];
	}
};
enum entity_script_value_type_t : u32 {
	nil,
	boolean,
	number = 3,
	string,
	table,
	reference = 0xfffffffb,
};
using entity_script_pair_t;
struct entity_script_table_t {
	entity_script_pair_t table[while (
		std::mem::read_unsigned($, 4) != entity_script_value_type_t::nil
	)];
	entity_script_value_type_t end_of_table_marker;
};
using entity_script_value_t;
struct entity_script_pair_t {
	entity_script_value_t key;
	entity_script_value_t value;
};
struct entity_script_value_t {
	entity_script_value_type_t type;
	match (type) {
		(entity_script_value_type_t::nil): padding[0];
		(entity_script_value_type_t::boolean): u8 value;
		(entity_script_value_type_t::number): double value;
		(entity_script_value_type_t::string): char value[];
		(entity_script_value_type_t::table): entity_script_table_t value;
		(entity_script_value_type_t::reference): u32 value;
		(_): std::error(std::format("bad type {} at 0x{:x}", type, $));
	}
} [[inline]];
struct entity_script_sound_t {
	u32 type;
	char path[];
};
struct entity_script_transition_t {
	char key[];
	u8 type;
	float transition_time; // ?
	double time; // ?
	u8 unknown_19[4];
};
struct entity_flags_t {
	if (tdbin_version >= 0x000902) {
		u16 flags;
	} else {
		u8 flags;
	}
} [[inline]];
tdbin_t tdbin @ 0;
