#ifndef _MSM_VIDC_H_
#define _MSM_VIDC_H_


struct msm_vidc_extradata_header {
	unsigned int size;
	unsigned int:32; /** Keeping binary compatibility */
	unsigned int:32; /* with firmware and OpenMAX IL **/
	unsigned int type; /* msm_vidc_extradata_type */
	unsigned int data_size;
	unsigned char data[1];
};

struct msm_vidc_interlace_payload {
	unsigned int format;
};
struct msm_vidc_framerate_payload {
	unsigned int frame_rate;
};
struct msm_vidc_ts_payload {
	unsigned int timestamp_lo;
	unsigned int timestamp_hi;
};
struct msm_vidc_concealmb_payload {
	unsigned int num_mbs;
};
struct msm_vidc_recoverysei_payload {
	unsigned int flags;
};

struct msm_vidc_aspect_ratio_payload {
	unsigned int size;
	unsigned int version;
	unsigned int port_index;
	unsigned int aspect_width;
	unsigned int aspect_height;
};

struct msm_vidc_mpeg2_seqdisp_payload {
	unsigned int video_format;
	bool color_descp;
	unsigned int color_primaries;
	unsigned int transfer_char;
	unsigned int matrix_coeffs;
	unsigned int disp_width;
	unsigned int disp_height;
};

struct msm_vidc_panscan_window {
	unsigned int panscan_height_offset;
	unsigned int panscan_width_offset;
	unsigned int panscan_window_width;
	unsigned int panscan_window_height;
};
struct msm_vidc_panscan_window_payload {
	unsigned int num_panscan_windows;
	struct msm_vidc_panscan_window wnd[1];
};
struct msm_vidc_s3d_frame_packing_payload {
	unsigned int fpa_id;
	unsigned int cancel_flag;
	unsigned int fpa_type;
	unsigned int quin_cunx_flag;
	unsigned int content_interprtation_type;
	unsigned int spatial_flipping_flag;
	unsigned int frame0_flipped_flag;
	unsigned int field_views_flag;
	unsigned int current_frame_is_frame0_flag;
	unsigned int frame0_self_contained_flag;
	unsigned int frame1_self_contained_flag;
	unsigned int frame0_graid_pos_x;
	unsigned int frame0_graid_pos_y;
	unsigned int frame1_graid_pos_x;
	unsigned int frame1_graid_pos_y;
	unsigned int fpa_reserved_byte;
	unsigned int fpa_repetition_period;
	unsigned int fpa_extension_flag;
};
struct msm_vidc_frame_qp_payload {
	unsigned int frame_qp;
};
struct msm_vidc_frame_bits_info_payload {
	unsigned int frame_bits;
	unsigned int header_bits;
};
struct msm_vidc_stream_userdata_payload {
	unsigned int type;
	unsigned int data[1];
};

enum msm_vidc_extradata_type {
	EXTRADATA_NONE = 0x00000000,
	EXTRADATA_MB_QUANTIZATION = 0x00000001,
	EXTRADATA_INTERLACE_VIDEO = 0x00000002,
	EXTRADATA_VC1_FRAMEDISP = 0x00000003,
	EXTRADATA_VC1_SEQDISP = 0x00000004,
	EXTRADATA_TIMESTAMP = 0x00000005,
	EXTRADATA_S3D_FRAME_PACKING = 0x00000006,
	EXTRADATA_FRAME_RATE = 0x00000007,
	EXTRADATA_PANSCAN_WINDOW = 0x00000008,
	EXTRADATA_RECOVERY_POINT_SEI = 0x00000009,
	EXTRADATA_MPEG2_SEQDISP = 0x0000000D,
	EXTRADATA_STREAM_USERDATA = 0x0000000E,
	EXTRADATA_FRAME_QP = 0x0000000F,
	EXTRADATA_FRAME_BITS_INFO = 0x00000010,
	EXTRADATA_MULTISLICE_INFO = 0x7F100000,
	EXTRADATA_NUM_CONCEALED_MB = 0x7F100001,
	EXTRADATA_INDEX = 0x7F100002,
	EXTRADATA_ASPECT_RATIO = 0x7F100003,
	EXTRADATA_METADATA_FILLER = 0x7FE00002,
	MSM_VIDC_EXTRADATA_METADATA_LTR = 0x7F100004,
	EXTRADATA_METADATA_MBI = 0x7F100005,
};
enum msm_vidc_interlace_type {
	INTERLACE_FRAME_PROGRESSIVE = 0x01,
	INTERLACE_INTERLEAVE_FRAME_TOPFIELDFIRST = 0x02,
	INTERLACE_INTERLEAVE_FRAME_BOTTOMFIELDFIRST = 0x04,
	INTERLACE_FRAME_TOPFIELDFIRST = 0x08,
	INTERLACE_FRAME_BOTTOMFIELDFIRST = 0x10,
};
enum msm_vidc_recovery_sei {
	FRAME_RECONSTRUCTION_INCORRECT = 0x0,
	FRAME_RECONSTRUCTION_CORRECT = 0x01,
	FRAME_RECONSTRUCTION_APPROXIMATELY_CORRECT = 0x02,
};

#endif
