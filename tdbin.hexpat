#pragma endian little
#include <std/mem.pat>
#include <std/io.pat>
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
};
tdbin_t tdbin @ 0;
