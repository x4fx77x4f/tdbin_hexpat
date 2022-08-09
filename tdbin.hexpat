#pragma endian little
#pragma pattern_limit 0x35000
#include <std/string.pat>
#include <std/math.pat>
#include <std/sys.pat>
#include <std/mem.pat>
namespace tdbin {
	struct vec_t {
		float x [[color("ff0000")]];
		float y [[color("00ff00")]];
		float z [[color("0000ff")]];
	} [[static, single_color, format("tdbin::vec_str")]];
	fn vec_str(vec_t vec) {
		return std::format(
			"Vec({:.3g}, {:.3g}, {:.3g})",
			vec.x, vec.y, vec.z
		);
	};
	struct quat_t {
		float x;
		float y;
		float z;
		float w;
	} [[static, single_color, format("tdbin::quat_str")]];
	fn quat_str(quat_t quat) {
		return std::format(
			"Quat({:.3g}, {:.3g}, {:.3g}, {:.3g})",
			quat.x, quat.y, quat.z, quat.w
		);
	};
	struct transform_t {
		vec_t pos;
		quat_t rot;
	} [[static, single_color, format("tdbin::transform_str")]];
	fn transform_str(transform_t transform) {
		return std::format(
			"Transform({:s}, {:s})",
			tdbin::vec_str(transform.pos),
			tdbin::quat_str(transform.rot)
		);
	};
	struct color_t {
		float r [[color("ff0000")]];
		float g [[color("00ff00")]];
		float b [[color("0000ff")]];
		float a [[color("777777")]];
	} [[static, single_color, format("tdbin::color_str")]];
	fn color_str(color_t color) {
		return std::format(
			"rgba({:.3g}, {:.3g}, {:.3g}, {:.3g});",
			color.r, color.g, color.b, color.a
		);
	};
	struct postprocessing_t {
		float brightness;
		color_t color_balance;
		float saturation;
		float gamma;
		float bloom;
	};
	struct player_t {
		transform_t transform;
		float yaw;
		float pitch;
		vec_t velocity;
		float health;
		padding[4*4];
	};
	struct environment_t {
		char skybox[];
		color_t skybox_tint;
		float skybox_brightness;
		float skybox_rotation;
		vec_t sun_brightness;
		color_t sun_color_tint;
		vec_t sun_direction;
		float brightness;
		float sun_spread;
		float sun_length;
		float sun_fog_scale;
		float sun_glare;
		padding[1];
		color_t constant;
		float ambient;
		float ambient_exponent;
		float exposure_min;
		float exposure_max;
		float brightness;
		color_t fog_color;
		float fog_start;
		float fog_end;
		float fog_amount;
		float fog_exponent;
		float wetness;
		float puddleamount;
		float puddlesize;
		float rain;
		bool nightlight;
		char ambience_path[];
		float ambience_volume;
		float slippery;
		float fog_scale;
		vec_t snow_direction;
		float snow_spread;
		float snow_amount;
		float snow_speed;
		bool snow_on_ground;
		vec_t wind_direction;
		float water_hurt;
	};
	struct boundary_vertex_t {
		float x [[color("ff0000")]];
		float z [[color("0000ff")]];
	} [[static, format("tdbin::boundary_vertex_str")]];
	fn boundary_vertex_str(boundary_vertex_t boundary_vertex) {
		return std::format(
			"{{{:.3g}, {:.3g}}}",
			boundary_vertex.x, boundary_vertex.z
		);
	};
	struct boundary_t {
		u32 vertex_count;
		boundary_vertex_t vertices[vertex_count];
		float pad_left;
		float pad_top;
		float pad_right;
		float pad_bottom;
	};
	struct fire_t {
		u32 entity;
		vec_t pos;
		float max_time;
		float time;
		padding[6];
	};
	struct material_t {
		u8 type;
		color_t color;
		float reflectivity;
		float shinyness;
		float metalness;
		float emission;
		bool replaceable;
	} [[static]];
	struct palette_t {
		material_t materials[256];
		padding[2*4*256];
		padding[1];
	} [[static]];
	struct tag_t {
		char key[];
		char value[];
	} [[format("tdbin::tag_str")]];
	fn tag_str(tag_t tag) {
		return std::format("'{:s}' = '{:s}'", tag.key, tag.value);
	};
	using entity_handle_t = u32;
	enum entity_type_t: u8 {
		body = 0x01,
		shape,
		light,
		location,
		water,
		joint,
		vehicle,
		wheel,
		screen,
		trigger,
		script,
	};
	enum entity_joint_type_t: u32 {
		ball = 0x00000001,
		hinge,
		prismatic,
		rope,
	};
	struct entity_rope_knot_t {
		vec_t from;
		vec_t to;
	} [[static]];
	struct entity_vehicle_exhaust_t {
		transform_t transform;
		padding[4];
	} [[static]];
	struct entity_vehicle_vital_t {
		entity_handle_t body_handle;
		vec_t position;
		padding[4];
		entity_handle_t shape_index; // Is this really a handle?
	} [[static]];
	enum entity_script_value_type_t: u32 {
		nil = 0x00000000,
		boolean = 0x00000001,
		number = 0x00000003,
		string = 0x00000004,
		table = 0x00000005,
		reference = 0xfffffffb,
	};
	using entity_script_table_t;
	struct entity_script_pair_t {
		entity_script_value_type_t key_type;
		if (key_type == entity_script_value_type_t::nil) {
			break;
		} else if (key_type == entity_script_value_type_t::boolean) {
			bool key;
		} else if (key_type == entity_script_value_type_t::number) {
			double key;
		} else if (key_type == entity_script_value_type_t::string) {
			char key[];
		} else if (key_type == entity_script_value_type_t::table) {
			entity_script_table_t key;
		} else if (key_type == entity_script_value_type_t::reference) {
			u32 key;
		} else {
			std::error(std::format("Unknown key type {:#010x}", key_type));
		}
		entity_script_value_type_t value_type;
		if (value_type == entity_script_value_type_t::boolean) {
			bool value;
		} else if (value_type == entity_script_value_type_t::number) {
			double value;
		} else if (value_type == entity_script_value_type_t::string) {
			char value[];
		} else if (value_type == entity_script_value_type_t::table) {
			entity_script_table_t value;
		} else if (value_type == entity_script_value_type_t::reference) {
			u32 value;
		} else if (value_type != entity_script_value_type_t::nil) {
			std::error(std::format("Unknown value type {:#010x}", value_type));
		}
	} [[format("tdbin::entity_script_pair_str")]];
	fn entity_script_pair_str(entity_script_pair_t pair) {
		str key;
		if (pair.key_type == entity_script_value_type_t::boolean) {
			key = pair.key == true ? "[true]" : "[false]";
		} else if (pair.key_type == entity_script_value_type_t::number) {
			key = std::format("[{:.3g}]", pair.key);
		} else if (pair.key_type == entity_script_value_type_t::string) {
			key = std::format("[\"{}\"]", pair.key);
		} else if (pair.key_type == entity_script_value_type_t::table) {
			key = "[{...}]";
		} else if (pair.key_type == entity_script_value_type_t::reference) {
			key = std::format("[--[[table: {:#010x}]]]", pair.key);
		} else {
			key = "[?]";
		}
		str value;
		if (pair.value_type == entity_script_value_type_t::boolean) {
			value = pair.value == true ? "true" : "false";
		} else if (pair.value_type == entity_script_value_type_t::number) {
			value = std::format("{:.3g}", pair.value);
		} else if (pair.value_type == entity_script_value_type_t::string) {
			value = std::format("\"{}\"", pair.value);
		} else if (pair.value_type == entity_script_value_type_t::table) {
			value = "{...}";
		} else if (pair.value_type == entity_script_value_type_t::reference) {
			value = std::format("--[[table: {:#010x}]]", pair.value);
		} else {
			value = "?";
		}
		return std::format("{} = {},", key, value);
	};
	struct entity_script_table_t {
		entity_script_pair_t table[while (
			std::mem::read_unsigned($, 4) != entity_script_value_type_t::nil
		)];
		entity_script_value_type_t end_of_table_marker;
	};
	struct entity_script_sound_t {
		u32 type;
		char path[];
	};
	struct entity_script_transition_t {
		char variable[];
		u8 type;
		float transition_time;
		double time;
		padding[4];
	};
	struct entity_t {
		entity_type_t type;
		entity_handle_t handle;
		u8 tag_count;
		tag_t tags[tag_count];
		char description[];
		if (type == entity_type_t::body) {
			u16 flags;
			transform_t transform;
			vec_t velocity;
			vec_t angular_velocity;
			bool dynamic;
			u8 body_flags;
		} else if (type == entity_type_t::shape) {
			u16 flags;
			transform_t transform;
			u8 shape_flags;
			padding[3];
			float density;
			float strength;
			u16 texture;
			u16 blendtexture;
			float texture_weight;
			float blendtexture_weight;
			vec_t starting_world_position;
			padding[4+1+1];
			u32 size_x;
			u32 size_y;
			u32 size_z;
			if (size_x*size_y*size_z > 0) {
				u32 encoded_length;
				std::assert(encoded_length % 2 == 0, "Bad encoded length");
				padding[encoded_length];
			}
			u32 palette;
			float scale;
			padding[4*2+1];
		} else if (type == entity_type_t::light) {
			u8 enabled;
			u8 light_type;
			transform_t transform;
			color_t color;
			float scale;
			float reach;
			float size;
			float unshadowed;
			float angle;
			float penumbra;
			float fogiter;
			float fogscale;
			float area_size_x;
			float area_size_z;
			float capsule_size;
			padding[13+4];
			char sound_path[];
			float sound_volume;
			float glare;
		} else if (type == entity_type_t::location) {
			u16 flags;
			transform_t transform;
		} else if (type == entity_type_t::water) {
			u16 flags;
			transform_t transform;
			float depth;
			float wave;
			float ripple;
			float motion;
			float foam;
			color_t color;
			u32 vertex_count;
			boundary_vertex_t vertices[vertex_count];
		} else if (type == entity_type_t::joint) {
			entity_joint_type_t joint_type;
			entity_handle_t shape_a;
			entity_handle_t shape_b;
			vec_t shape_a_position;
			vec_t shape_b_position;
			vec_t shape_a_axes;
			vec_t shape_b_axes;
			bool connected;
			bool collide;
			float rotstrength;
			float rotspring;
			quat_t rotation;
			float limit_min;
			float limit_max;
			padding[4*2];
			float size;
			bool sound;
			bool autodisable;
			padding[4*2];
			if (joint_type == entity_joint_type_t::rope) {
				color_t color;
				padding[4];
				float strength;
				float maxstretch;
				float slack;
				padding[4+1];
				u32 knot_count;
				entity_rope_knot_t knots[knot_count];
			}
		} else if (type == entity_type_t::vehicle) {
			u16 flags;
			entity_handle_t body_handle;
			transform_t transform;
			vec_t velocity;
			vec_t angular_velocity;
			padding[4];
			u32 wheel_count;
			entity_handle_t wheel_handles[wheel_count];
			float topspeed;
			padding[4];
			float spring;
			float damping;
			float acceleration;
			float strength;
			float friction;
			padding[4+1];
			float antispin;
			float steerassist;
			padding[4];
			float antiroll;
			char sound[];
			float pitch;
			vec_t camera_position;
			vec_t player_position;
			vec_t exit_position;
			vec_t propeller_position;
			float difflock;
			padding[4+4+1+4];
			u32 ref_count; // What is a "ref"?
			u32 refs[ref_count];
			u32 exhaust_count;
			entity_vehicle_exhaust_t exhausts[exhaust_count];
			u32 vital_count;
			entity_vehicle_vital_t vitals[vital_count];
			padding[4+1+4];
		} else if (type == entity_type_t::wheel) {
			u16 flags;
			entity_handle_t vehicle_handle;
			entity_handle_t vehicle_body_handle;
			entity_handle_t body_handle;
			entity_handle_t shape_handle;
			transform_t transform;
			padding[4*7];
			float steer;
			float drive;
			float travel_min;
			float travel_max;
			padding[4*2];
			float angular_speed;
			padding[4*2];
		} else if (type == entity_type_t::screen) {
			u16 flags;
			transform_t transform;
			float width;
			float height;
			float bulge;
			u32 resolution_width;
			u32 resolution_height;
			char script[];
			bool enabled;
			bool interactive;
			float emissive;
			float fxraster;
			float fxca;
			float fxnoise;
			float fxglitch; // TODO: verify
		} else if (type == entity_type_t::trigger) {
			u16 flags;
			transform_t transform;
			u32 trigger_type;
			float sphere_size;
			vec_t box_size;
			float polygon_size;
			u32 vertex_count;
			boundary_vertex_t vertices[vertex_count];
			char sound[];
			float soundramp;
			padding[1];
			float sound_volume;
		} else if (type == entity_type_t::script) {
			u16 flags;
			char file[];
			u32 parameter_count;
			tag_t parameters[parameter_count];
			float last_update;
			float time;
			padding[4];
			entity_script_table_t environment;
			u32 handle_count;
			u32 handles[handle_count];
			u32 sound_count;
			entity_script_sound_t sounds[sound_count];
			u32 transition_count;
			entity_script_transition_t transitions[transition_count];
		} else {
			std::error(std::format("Unknown entity type {:#04x}", type));
		}
		u32 child_count;
		entity_t children[child_count];
		u32 pad [[hidden]];
		std::assert(pad == 0xbeefbeef, "Bad entity padding");
	} [[format("tdbin::entity_str")]];
	fn entity_str(entity_t entity) {
		return std::format("{:d} <{}>", entity.handle, entity.type);
	};
	struct tdbin_t {
		char magic[5];
		std::assert(magic == "TDBIN", "Bad magic");
		be u24 version;
		std::print(
			"TDBIN {:d}.{:d}.{:d}",
			(version & 0xff0000) >> 16,
			(version & 0xff00) >> 8,
			version & 0xff
		);
		char level[];
		padding[4];
		vec_t shadow_volume;
		transform_t spawnpoint;
		padding[4*3];
		if (version >= 0x010100) padding[4];
		if (version >= 0x010000) postprocessing_t postprocessing;
		player_t player;
		environment_t environment;
		boundary_t boundary;
		u32 fire_count;
		fire_t fires[fire_count];
		u32 palette_count;
		palette_t palettes[palette_count];
		u32 registry_count;
		tag_t registry[registry_count];
		u32 entity_count;
		entity_t entities[entity_count];
	};
}
tdbin::tdbin_t tdbin @ 0;
