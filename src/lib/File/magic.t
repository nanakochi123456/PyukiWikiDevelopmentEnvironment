#----------------------------------------------------------------------
# $Id$
# "magic file for File::MMagic" version 1.27 $$
#----------------------------------------------------------------------
# animation:  file(1) magic for animation/movie formats
# animation formats
# MPEG, FLI, DL originally from vax@ccwf.cc.utexas.edu (VaX#n8)
# FLC, SGI, Apple originally from Daniel Quinlan (quinlan@yggdrasil.com)
0	string	MOVI	Silicon Graphics movie file
4	string	moov	Apple QuickTime
>12	string	mvhd	\b movie (fast start)
>12	string	mdra	\b URL
>12	string	cmov	\b movie (fast start, compressed header)
>12	string	rmra	\b multiple URLs
4	string	mdat	Apple QuickTime movie (unoptimized)
4	string	wide	Apple QuickTime movie (unoptimized)
4	string	skip	Apple QuickTime movie (modified)
4	string	free	Apple QuickTime movie (modified)
4	string	idsc	Apple QuickTime image (fast start)
4	string	idat	Apple QuickTime image (unoptimized)
4	string	pckg	Apple QuickTime compressed archive
4	string/B	jP	JPEG 2000 image
4	string	ftyp	ISO Media
>8	string	isom	\b, MPEG v4 system, version 1
>8	string	iso2	\b, MPEG v4 system, part 12 revision
>8	string	mp41	\b, MPEG v4 system, version 1
>8	string	mp42	\b, MPEG v4 system, version 2
>8	string	mp7t	\b, MPEG v4 system, MPEG v7 XML
>8	string	mp7b	\b, MPEG v4 system, MPEG v7 binary XML
>8	string/B	jp2	\b, JPEG 2000
>8	string	3gp	\b, MPEG v4 system, 3GPP
>>11	byte	4	\b v4 (H.263/AMR GSM 6.10)
>>11	byte	5	\b v5 (H.263/AMR GSM 6.10)
>>11	byte	6	\b v6 (ITU H.264/AMR GSM 6.10)
>8	string	mmp4	\b, MPEG v4 system, 3GPP Mobile
>8	string	avc1	\b, MPEG v4 system, 3GPP JVT AVC
>8	string/B	M4A	\b, MPEG v4 system, iTunes AAC-LC
>8	string/B	M4P	\b, MPEG v4 system, iTunes AES encrypted
>8	string/B	M4B	\b, MPEG v4 system, iTunes bookmarked
>8	string/B	qt	\b, Apple QuickTime movie
0	belong	0x00000001	JVT NAL sequence
>4	byte&0x1F	0x07	\b, H.264 video
>>5	byte	66	\b, baseline
>>5	byte	77	\b, main
>>5	byte	88	\b, extended
>>7	byte	x	\b @ L %u
0	belong&0xFFFFFF00	0x00000100	MPEG sequence
>3	byte	0xBA
>>4	byte	&0x40	\b, v2, program multiplex
>>4	byte	^0x40	\b, v1, system multiplex
>3	byte	0xBB	\b, v1/2, multiplex (missing pack header)
>3	byte&0x1F	0x07	\b, H.264 video
>>4	byte	66	\b, baseline
>>4	byte	77	\b, main
>>4	byte	88	\b, extended
>>6	byte	x	\b @ L %u
>3	byte	0xB0	\b, v4
>>5	belong	0x000001B5
>>>9	byte	&0x80
>>>>10	byte&0xF0	16	\b, video
>>>>10	byte&0xF0	32	\b, still texture
>>>>10	byte&0xF0	48	\b, mesh
>>>>10	byte&0xF0	64	\b, face
>>>9	byte&0xF8	8	\b, video
>>>9	byte&0xF8	16	\b, still texture
>>>9	byte&0xF8	24	\b, mesh
>>>9	byte&0xF8	32	\b, face
>>4	byte	1	\b, simple @ L1
>>4	byte	2	\b, simple @ L2
>>4	byte	3	\b, simple @ L3
>>4	byte	4	\b, simple @ L0
>>4	byte	17	\b, simple scalable @ L1
>>4	byte	18	\b, simple scalable @ L2
>>4	byte	33	\b, core @ L1
>>4	byte	34	\b, core @ L2
>>4	byte	50	\b, main @ L2
>>4	byte	51	\b, main @ L3
>>4	byte	53	\b, main @ L4
>>4	byte	66	\b, n-bit @ L2
>>4	byte	81	\b, scalable texture @ L1
>>4	byte	97	\b, simple face animation @ L1
>>4	byte	98	\b, simple face animation @ L2
>>4	byte	99	\b, simple face basic animation @ L1
>>4	byte	100	\b, simple face basic animation @ L2
>>4	byte	113	\b, basic animation text @ L1
>>4	byte	114	\b, basic animation text @ L2
>>4	byte	129	\b, hybrid @ L1
>>4	byte	130	\b, hybrid @ L2
>>4	byte	145	\b, advanced RT simple @ L!
>>4	byte	146	\b, advanced RT simple @ L2
>>4	byte	147	\b, advanced RT simple @ L3
>>4	byte	148	\b, advanced RT simple @ L4
>>4	byte	161	\b, core scalable @ L1
>>4	byte	162	\b, core scalable @ L2
>>4	byte	163	\b, core scalable @ L3
>>4	byte	177	\b, advanced coding efficiency @ L1
>>4	byte	178	\b, advanced coding efficiency @ L2
>>4	byte	179	\b, advanced coding efficiency @ L3
>>4	byte	180	\b, advanced coding efficiency @ L4
>>4	byte	193	\b, advanced core @ L1
>>4	byte	194	\b, advanced core @ L2
>>4	byte	209	\b, advanced scalable texture @ L1
>>4	byte	210	\b, advanced scalable texture @ L2
>>4	byte	211	\b, advanced scalable texture @ L3
>>4	byte	225	\b, simple studio @ L1
>>4	byte	226	\b, simple studio @ L2
>>4	byte	227	\b, simple studio @ L3
>>4	byte	228	\b, simple studio @ L4
>>4	byte	229	\b, core studio @ L1
>>4	byte	230	\b, core studio @ L2
>>4	byte	231	\b, core studio @ L3
>>4	byte	232	\b, core studio @ L4
>>4	byte	240	\b, advanced simple @ L0
>>4	byte	241	\b, advanced simple @ L1
>>4	byte	242	\b, advanced simple @ L2
>>4	byte	243	\b, advanced simple @ L3
>>4	byte	244	\b, advanced simple @ L4
>>4	byte	245	\b, advanced simple @ L5
>>4	byte	247	\b, advanced simple @ L3b
>>4	byte	248	\b, FGS @ L0
>>4	byte	249	\b, FGS @ L1
>>4	byte	250	\b, FGS @ L2
>>4	byte	251	\b, FGS @ L3
>>4	byte	252	\b, FGS @ L4
>>4	byte	253	\b, FGS @ L5
>3	byte	0xB5	\b, v4
>>4	byte	&0x80
>>>5	byte&0xF0	16	\b, video (missing profile header)
>>>5	byte&0xF0	32	\b, still texture (missing profile header)
>>>5	byte&0xF0	48	\b, mesh (missing profile header)
>>>5	byte&0xF0	64	\b, face (missing profile header)
>>4	byte&0xF8	8	\b, video (missing profile header)
>>4	byte&0xF8	16	\b, still texture (missing profile header)
>>4	byte&0xF8	24	\b, mesh (missing profile header)
>>4	byte&0xF8	32	\b, face (missing profile header)
>3	byte	0xB3
>>12	belong	0x000001B8	\b, v1, progressive Y'CbCr 4:2:0 video
>>12	belong	0x000001B2	\b, v1, progressive Y'CbCr 4:2:0 video
>>12	belong	0x000001B5	\b, v2,
>>>16	byte&0x0F	1	\b HP
>>>16	byte&0x0F	2	\b Spt
>>>16	byte&0x0F	3	\b SNR
>>>16	byte&0x0F	4	\b MP
>>>16	byte&0x0F	5	\b SP
>>>17	byte&0xF0	64	\b@HL
>>>17	byte&0xF0	96	\b@H-14
>>>17	byte&0xF0	128	\b@ML
>>>17	byte&0xF0	160	\b@LL
>>>17	byte	&0x08	\b progressive
>>>17	byte	^0x08	\b interlaced
>>>17	byte&0x06	2	\b Y'CbCr 4:2:0 video
>>>17	byte&0x06	4	\b Y'CbCr 4:2:2 video
>>>17	byte&0x06	6	\b Y'CbCr 4:4:4 video
>>11	byte	&0x02
>>>75	byte	&0x01
>>>>140	belong	0x000001B8	\b, v1, progressive Y'CbCr 4:2:0 video
>>>>140	belong	0x000001B2	\b, v1, progressive Y'CbCr 4:2:0 video
>>>>140	belong	0x000001B5	\b, v2,
>>>>>144 byte&0x0F	1	\b HP
>>>>>144 byte&0x0F	2	\b Spt
>>>>>144 byte&0x0F	3	\b SNR
>>>>>144 byte&0x0F	4	\b MP
>>>>>144 byte&0x0F	5	\b SP
>>>>>145 byte&0xF0	64	\b@HL
>>>>>145 byte&0xF0	96	\b@H-14
>>>>>145 byte&0xF0	128	\b@ML
>>>>>145 byte&0xF0	160	\b@LL
>>>>>145 byte	&0x08	\b progressive
>>>>>145 byte	^0x08	\b interlaced
>>>>>145 byte&0x06	2	\b Y'CbCr 4:2:0 video
>>>>>145 byte&0x06	4	\b Y'CbCr 4:2:2 video
>>>>>145 byte&0x06	6	\b Y'CbCr 4:4:4 video
>>76	belong	0x000001B8	\b, v1, progressive Y'CbCr 4:2:0 video
>>76	belong	0x000001B2	\b, v1, progressive Y'CbCr 4:2:0 video
>>76	belong	0x000001B5	\b, v2,
>>>80	byte&0x0F	1	\b HP
>>>80	byte&0x0F	2	\b Spt
>>>80	byte&0x0F	3	\b SNR
>>>80	byte&0x0F	4	\b MP
>>>80	byte&0x0F	5	\b SP
>>>81	byte&0xF0	64	\b@HL
>>>81	byte&0xF0	96	\b@H-14
>>>81	byte&0xF0	128	\b@ML
>>>81	byte&0xF0	160	\b@LL
>>>81	byte	&0x08	\b progressive
>>>81	byte	^0x08	\b interlaced
>>>81	byte&0x06	2	\b Y'CbCr 4:2:0 video
>>>81	byte&0x06	4	\b Y'CbCr 4:2:2 video
>>>81	byte&0x06	6	\b Y'CbCr 4:4:4 video
>>4	belong&0xFFFFFF00	0x78043800	\b, HD-TV 1920P
>>>7	byte&0xF0	0x10	\b, 16:9
>>4	belong&0xFFFFFF00	0x50002D00	\b, SD-TV 1280I
>>>7	byte&0xF0	0x10	\b, 16:9
>>4	belong&0xFFFFFF00	0x30024000	\b, PAL Capture
>>>7	byte&0xF0	0x10	\b, 4:3
>>4	beshort&0xFFF0	0x2C00	\b, 4CIF
>>>5	beshort&0x0FFF	0x01E0	\b NTSC
>>>5	beshort&0x0FFF	0x0240	\b PAL
>>>7	byte&0xF0	0x20	\b, 4:3
>>>7	byte&0xF0	0x30	\b, 16:9
>>>7	byte&0xF0	0x40	\b, 11:5
>>>7	byte&0xF0	0x80	\b, PAL 4:3
>>>7	byte&0xF0	0xC0	\b, NTSC 4:3
>>4	belong&0xFFFFFF00	0x2801E000	\b, LD-TV 640P
>>>7	byte&0xF0	0x10	\b, 4:3
>>4	belong&0xFFFFFF00	0x1400F000	\b, 320x240
>>>7	byte&0xF0	0x10	\b, 4:3
>>4	belong&0xFFFFFF00	0x0F00A000	\b, 240x160
>>>7	byte&0xF0	0x10	\b, 4:3
>>4	belong&0xFFFFFF00	0x0A007800	\b, 160x120
>>>7	byte&0xF0	0x10	\b, 4:3
>>4	beshort&0xFFF0	0x1600	\b, CIF
>>>5	beshort&0x0FFF	0x00F0	\b NTSC
>>>5	beshort&0x0FFF	0x0120	\b PAL
>>>7	byte&0xF0	0x20	\b, 4:3
>>>7	byte&0xF0	0x30	\b, 16:9
>>>7	byte&0xF0	0x40	\b, 11:5
>>>7	byte&0xF0	0x80	\b, PAL 4:3
>>>7	byte&0xF0	0xC0	\b, NTSC 4:3
>>>5	beshort&0x0FFF	0x0240	\b PAL 625
>>>>7	byte&0xF0	0x20	\b, 4:3
>>>>7	byte&0xF0	0x30	\b, 16:9
>>>>7	byte&0xF0	0x40	\b, 11:5
>>4	beshort&0xFFF0	0x2D00	\b, CCIR/ITU
>>>5	beshort&0x0FFF	0x01E0	\b NTSC 525
>>>5	beshort&0x0FFF	0x0240	\b PAL 625
>>>7	byte&0xF0	0x20	\b, 4:3
>>>7	byte&0xF0	0x30	\b, 16:9
>>>7	byte&0xF0	0x40	\b, 11:5
>>4	beshort&0xFFF0	0x1E00	\b, SVCD
>>>5	beshort&0x0FFF	0x01E0	\b NTSC 525
>>>5	beshort&0x0FFF	0x0240	\b PAL 625
>>>7	byte&0xF0	0x20	\b, 4:3
>>>7	byte&0xF0	0x30	\b, 16:9
>>>7	byte&0xF0	0x40	\b, 11:5
>>7	byte&0x0F	1	\b, 23.976 fps
>>7	byte&0x0F	2	\b, 24 fps
>>7	byte&0x0F	3	\b, 25 fps
>>7	byte&0x0F	4	\b, 29.97 fps
>>7	byte&0x0F	5	\b, 30 fps
>>7	byte&0x0F	6	\b, 50 fps
>>7	byte&0x0F	7	\b, 59.94 fps
>>7	byte&0x0F	8	\b, 60 fps
>>11	byte	&0x04	\b, Constrained
0	beshort&0xFFFE	0xFFFA	MPEG ADTS, layer III, v1
>2	byte&0xF0	0x10	\b,	32 kBits
>2	byte&0xF0	0x20	\b,	40 kBits
>2	byte&0xF0	0x30	\b,	48 kBits
>2	byte&0xF0	0x40	\b,	56 kBits
>2	byte&0xF0	0x50	\b,	64 kBits
>2	byte&0xF0	0x60	\b,	80 kBits
>2	byte&0xF0	0x70	\b,	96 kBits
>2	byte&0xF0	0x80	\b, 112 kBits
>2	byte&0xF0	0x90	\b, 128 kBits
>2	byte&0xF0	0xA0	\b, 160 kBits
>2	byte&0xF0	0xB0	\b, 192 kBits
>2	byte&0xF0	0xC0	\b, 224 kBits
>2	byte&0xF0	0xD0	\b, 256 kBits
>2	byte&0xF0	0xE0	\b, 320 kBits
>2	byte&0x0C	0x00	\b, 44.1 kHz
>2	byte&0x0C	0x04	\b, 48 kHz
>2	byte&0x0C	0x08	\b, 32 kHz
>3	byte&0xC0	0x00	\b, Stereo
>3	byte&0xC0	0x40	\b, JntStereo
>3	byte&0xC0	0x80	\b, 2x Monaural
>3	byte&0xC0	0xC0	\b, Monaural
0	beshort&0xFFFE	0xFFFC	MPEG ADTS, layer II, v1
>2	byte&0xF0	0x10	\b,	32 kBits
>2	byte&0xF0	0x20	\b,	48 kBits
>2	byte&0xF0	0x30	\b,	56 kBits
>2	byte&0xF0	0x40	\b,	64 kBits
>2	byte&0xF0	0x50	\b,	80 kBits
>2	byte&0xF0	0x60	\b,	96 kBits
>2	byte&0xF0	0x70	\b, 112 kBits
>2	byte&0xF0	0x80	\b, 128 kBits
>2	byte&0xF0	0x90	\b, 160 kBits
>2	byte&0xF0	0xA0	\b, 192 kBits
>2	byte&0xF0	0xB0	\b, 224 kBits
>2	byte&0xF0	0xC0	\b, 256 kBits
>2	byte&0xF0	0xD0	\b, 320 kBits
>2	byte&0xF0	0xE0	\b, 384 kBits
>2	byte&0x0C	0x00	\b, 44.1 kHz
>2	byte&0x0C	0x04	\b, 48 kHz
>2	byte&0x0C	0x08	\b, 32 kHz
>3	byte&0xC0	0x00	\b, Stereo
>3	byte&0xC0	0x40	\b, JntStereo
>3	byte&0xC0	0x80	\b, 2x Monaural
>3	byte&0xC0	0xC0	\b, Monaural
0	beshort&0xFFFE	0xFFFE	
>2	byte&0xF0	>0x0F	
>>2	byte&0xF0	<0xE1	MPEG ADTS, layer I, v1
>>>2	byte&0xF0	0x10	\b,	32 kBits
>>>2	byte&0xF0	0x20	\b,	64 kBits
>>>2	byte&0xF0	0x30	\b,	96 kBits
>>>2	byte&0xF0	0x40	\b, 128 kBits
>>>2	byte&0xF0	0x50	\b, 160 kBits
>>>2	byte&0xF0	0x60	\b, 192 kBits
>>>2	byte&0xF0	0x70	\b, 224 kBits
>>>2	byte&0xF0	0x80	\b, 256 kBits
>>>2	byte&0xF0	0x90	\b, 288 kBits
>>>2	byte&0xF0	0xA0	\b, 320 kBits
>>>2	byte&0xF0	0xB0	\b, 352 kBits
>>>2	byte&0xF0	0xC0	\b, 384 kBits
>>>2	byte&0xF0	0xD0	\b, 416 kBits
>>>2	byte&0xF0	0xE0	\b, 448 kBits
>>>2	byte&0x0C	0x00	\b, 44.1 kHz
>>>2	byte&0x0C	0x04	\b, 48 kHz
>>>2	byte&0x0C	0x08	\b, 32 kHz
>>>3	byte&0xC0	0x00	\b, Stereo
>>>3	byte&0xC0	0x40	\b, JntStereo
>>>3	byte&0xC0	0x80	\b, 2x Monaural
>>>3	byte&0xC0	0xC0	\b, Monaural
0	beshort&0xFFFE	0xFFF2	MPEG ADTS, layer III, v2
>2	byte&0xF0	0x10	\b,	8 kBits
>2	byte&0xF0	0x20	\b,	16 kBits
>2	byte&0xF0	0x30	\b,	24 kBits
>2	byte&0xF0	0x40	\b,	32 kBits
>2	byte&0xF0	0x50	\b,	40 kBits
>2	byte&0xF0	0x60	\b,	48 kBits
>2	byte&0xF0	0x70	\b,	56 kBits
>2	byte&0xF0	0x80	\b,	64 kBits
>2	byte&0xF0	0x90	\b,	80 kBits
>2	byte&0xF0	0xA0	\b,	96 kBits
>2	byte&0xF0	0xB0	\b, 112 kBits
>2	byte&0xF0	0xC0	\b, 128 kBits
>2	byte&0xF0	0xD0	\b, 144 kBits
>2	byte&0xF0	0xE0	\b, 160 kBits
>2	byte&0x0C	0x00	\b, 22.05 kHz
>2	byte&0x0C	0x04	\b, 24 kHz
>2	byte&0x0C	0x08	\b, 16 kHz
>3	byte&0xC0	0x00	\b, Stereo
>3	byte&0xC0	0x40	\b, JntStereo
>3	byte&0xC0	0x80	\b, 2x Monaural
>3	byte&0xC0	0xC0	\b, Monaural
0	beshort&0xFFFE	0xFFF4	MPEG ADTS, layer II, v2
>2	byte&0xF0	0x10	\b,	8 kBits
>2	byte&0xF0	0x20	\b,	16 kBits 
>2	byte&0xF0	0x30	\b,	24 kBits
>2	byte&0xF0	0x40	\b,	32 kBits
>2	byte&0xF0	0x50	\b,	40 kBits
>2	byte&0xF0	0x60	\b,	48 kBits
>2	byte&0xF0	0x70	\b,	56 kBits
>2	byte&0xF0	0x80	\b,	64 kBits
>2	byte&0xF0	0x90	\b,	80 kBits
>2	byte&0xF0	0xA0	\b,	96 kBits
>2	byte&0xF0	0xB0	\b, 112 kBits
>2	byte&0xF0	0xC0	\b, 128 kBits
>2	byte&0xF0	0xD0	\b, 144 kBits
>2	byte&0xF0	0xE0	\b, 160 kBits
>2	byte&0x0C	0x00	\b, 22.05 kHz
>2	byte&0x0C	0x04	\b, 24 kHz
>2	byte&0x0C	0x08	\b, 16 kHz
>3	byte&0xC0	0x00	\b, Stereo
>3	byte&0xC0	0x40	\b, JntStereo
>3	byte&0xC0	0x80	\b, 2x Monaural
>3	byte&0xC0	0xC0	\b, Monaural
0	beshort&0xFFFE	0xFFF6	MPEG ADTS, layer I, v2
>2	byte&0xF0	0x10	\b,	32 kBits
>2	byte&0xF0	0x20	\b,	48 kBits
>2	byte&0xF0	0x30	\b,	56 kBits
>2	byte&0xF0	0x40	\b,	64 kBits
>2	byte&0xF0	0x50	\b,	80 kBits
>2	byte&0xF0	0x60	\b,	96 kBits
>2	byte&0xF0	0x70	\b, 112 kBits
>2	byte&0xF0	0x80	\b, 128 kBits
>2	byte&0xF0	0x90	\b, 144 kBits
>2	byte&0xF0	0xA0	\b, 160 kBits
>2	byte&0xF0	0xB0	\b, 176 kBits
>2	byte&0xF0	0xC0	\b, 192 kBits
>2	byte&0xF0	0xD0	\b, 224 kBits
>2	byte&0xF0	0xE0	\b, 256 kBits
>2	byte&0x0C	0x00	\b, 22.05 kHz
>2	byte&0x0C	0x04	\b, 24 kHz
>2	byte&0x0C	0x08	\b, 16 kHz
>3	byte&0xC0	0x00	\b, Stereo
>3	byte&0xC0	0x40	\b, JntStereo
>3	byte&0xC0	0x80	\b, 2x Monaural
>3	byte&0xC0	0xC0	\b, Monaural
0	beshort&0xFFFE	0xFFE2	MPEG ADTS, layer III,	v2.5
>2	byte&0xF0	0x10	\b,	8 kBits
>2	byte&0xF0	0x20	\b,	16 kBits
>2	byte&0xF0	0x30	\b,	24 kBits
>2	byte&0xF0	0x40	\b,	32 kBits
>2	byte&0xF0	0x50	\b,	40 kBits
>2	byte&0xF0	0x60	\b,	48 kBits
>2	byte&0xF0	0x70	\b,	56 kBits
>2	byte&0xF0	0x80	\b,	64 kBits
>2	byte&0xF0	0x90	\b,	80 kBits
>2	byte&0xF0	0xA0	\b,	96 kBits
>2	byte&0xF0	0xB0	\b, 112 kBits
>2	byte&0xF0	0xC0	\b, 128 kBits
>2	byte&0xF0	0xD0	\b, 144 kBits
>2	byte&0xF0	0xE0	\b, 160 kBits
>2	byte&0x0C	0x00	\b, 11.025 kHz
>2	byte&0x0C	0x04	\b, 12 kHz
>2	byte&0x0C	0x08	\b, 8 kHz
>3	byte&0xC0	0x00	\b, Stereo
>3	byte&0xC0	0x40	\b, JntStereo
>3	byte&0xC0	0x80	\b, 2x Monaural
>3	byte&0xC0	0xC0	\b, Monaural
0	string	ADIF	MPEG ADIF, AAC
>4	byte	&0x80
>>13	byte	&0x10	\b, VBR
>>13	byte	^0x10	\b, CBR
>>16	byte&0x1E	0x02	\b, single stream
>>16	byte&0x1E	0x04	\b, 2 streams
>>16	byte&0x1E	0x06	\b, 3 streams
>>16	byte	&0x08	\b, 4 or more streams
>>16	byte	&0x10	\b, 8 or more streams
>>4	byte	&0x80	\b, Copyrighted
>>13	byte	&0x40	\b, Original Source
>>13	byte	&0x20	\b, Home Flag
>4	byte	^0x80
>>4	byte	&0x10	\b, VBR
>>4	byte	^0x10	\b, CBR
>>7	byte&0x1E	0x02	\b, single stream
>>7	byte&0x1E	0x04	\b, 2 streams
>>7	byte&0x1E	0x06	\b, 3 streams
>>7	byte	&0x08	\b, 4 or more streams
>>7	byte	&0x10	\b, 8 or more streams
>>4	byte	&0x40	\b, Original Stream(s)
>>4	byte	&0x20	\b, Home Source
0	beshort&0xFFF6	0xFFF0	MPEG ADTS, AAC
>1	byte	&0x08	\b, v2
>1	byte	^0x08	\b, v4
>>2	byte	&0xC0	\b LTP
>2	byte&0xc0	0x00	\b Main
>2	byte&0xc0	0x40	\b LC
>2	byte&0xc0	0x80	\b SSR
>2	byte&0x3c	0x00	\b, 96 kHz
>2	byte&0x3c	0x04	\b, 88.2 kHz
>2	byte&0x3c	0x08	\b, 64 kHz
>2	byte&0x3c	0x0c	\b, 48 kHz
>2	byte&0x3c	0x10	\b, 44.1 kHz
>2	byte&0x3c	0x14	\b, 32 kHz
>2	byte&0x3c	0x18	\b, 24 kHz
>2	byte&0x3c	0x1c	\b, 22.05 kHz
>2	byte&0x3c	0x20	\b, 16 kHz
>2	byte&0x3c	0x24	\b, 12 kHz
>2	byte&0x3c	0x28	\b, 11.025 kHz
>2	byte&0x3c	0x2c	\b, 8 kHz
>2	beshort&0x01c0	0x0040	\b, monaural
>2	beshort&0x01c0	0x0080	\b, stereo
>2	beshort&0x01c0	0x00c0	\b, stereo + center
>2	beshort&0x01c0	0x0100	\b, stereo+center+LFE
>2	beshort&0x01c0	0x0140	\b, surround
>2	beshort&0x01c0	0x0180	\b, surround + LFE
>2	beshort	&0x01C0	\b, surround + side
0	beshort&0xFFE0	0x56E0	MPEG-4 LOAS
>3	byte&0xE0	0x40
>>4	byte&0x3C	0x04	\b, single stream
>>4	byte&0x3C	0x08	\b, 2 streams
>>4	byte&0x3C	0x0C	\b, 3 streams
>>4	byte	&0x08	\b, 4 or more streams
>>4	byte	&0x20	\b, 8 or more streams
>3	byte&0xC0	0
>>4	byte&0x78	0x08	\b, single stream
>>4	byte&0x78	0x10	\b, 2 streams
>>4	byte&0x78	0x18	\b, 3 streams
>>4	byte	&0x20	\b, 4 or more streams
>>4	byte	&0x40	\b, 8 or more streams
4	leshort	0xAF11	FLI file
>6	leshort	x	- %d frames,
>8	leshort	x	width=%d pixels,
>10	leshort	x	height=%d pixels,
>12	leshort	x	depth=%d,
>16	leshort	x	ticks/frame=%d
4	leshort	0xAF12	FLC file
>6	leshort	x	- %d frames
>8	leshort	x	width=%d pixels,
>10	leshort	x	height=%d pixels,
>12	leshort	x	depth=%d,
>16	leshort	x	ticks/frame=%d
0	belong&0xFF5FFF1F	0x47400010	MPEG transport stream data
>188	byte	!0x47	CORRUPTED
0	belong&0xffffff00	0x1f070000	DIF
>4	byte	&0x01	(DVCPRO) movie file
>4	byte	^0x01	(DV) movie file
>3	byte	&0x80	(PAL)
>3	byte	^0x80	(NTSC)
0	belong	0x3026b275	Microsoft ASF
0	string	\x8aMNG	MNG video data,
>4	belong	!0x0d0a1a0a	CORRUPTED,
>4	belong	0x0d0a1a0a
>>16	belong	x	%ld x
>>20	belong	x	%ld
0	string	\x8bJNG	JNG video data,
>4	belong	!0x0d0a1a0a	CORRUPTED,
>4	belong	0x0d0a1a0a
>>16	belong	x	%ld x
>>20	belong	x	%ld
3	string	\x0D\x0AVersion:Vivo	Vivo video data
0	string/b	#VRML\ V1.0\ ascii	VRML 1 file
0	string/b	#VRML\ V2.0\ utf8	ISO/IEC 14772 VRML 97 file
#----------------------------------------------------------------------
# archive:  file(1) magic for archive formats (see also "msdos" for self-
#	extracting compressed archives)
# cpio, ar, arc, arj, hpack, lha/lharc, rar, squish, uc2, zip, zoo, etc.
# pre-POSIX "tar" archives are handled in the C code.
257	string	ustar\0	POSIX tar archive
257	string	ustar\040\040\0	GNU tar archive
0	short	070707	cpio archive
0	short	0143561	byte-swapped cpio archive
0	string	070707	ASCII cpio archive (pre-SVR4 or odc)
0	string	070701	ASCII cpio archive (SVR4 with no CRC)
0	string	070702	ASCII cpio archive (SVR4 with CRC)
0	string	=!<arch>\ndebian
>8	string	debian-split	part of multipart Debian package
>8	string	debian-binary	Debian binary package
>68	string	>\0	(format %s)
0	long	0177555	very old archive
0	short	0177555	very old PDP-11 archive
0	long	0177545	old archive
0	short	0177545	old PDP-11 archive
0	long	0100554	apl workspace
0	string	=<ar>	archive
0	string	=!<arch>\n__________E	MIPS archive
>20	string	U	with MIPS Ucode members
>21	string	L	with MIPSEL members
>21	string	B	with MIPSEB members
>19	string	L	and an EL hash table
>19	string	B	and an EB hash table
>22	string	X	-- out of date
0	string	-h-	Software Tools format archive text
0	string	=!<arch>	current ar archive
>8	string	__.SYMDEF	random library
>0	belong	=65538	- pre SR9.5
>0	belong	=65539	- post SR9.5
>0	beshort	2	- object archive
>0	beshort	3	- shared library module
>0	beshort	4	- debug break-pointed module
>0	beshort	5	- absolute code program module
0	string	\<ar>	System V Release 1 ar archive
0	string	=<ar>	archive
0	belong	0x65ff0000	VAX 3.0 archive
0	belong	0x3c61723e	VAX 5.0 archive
0	long	0x213c6172	archive file
0	lelong	0177555	very old VAX archive
0	leshort	0177555	very old PDP-11 archive
0	lelong	0177545	old VAX archive
>8	string	__.SYMDEF	random library
0	leshort	0177545	old PDP-11 archive
>8	string	__.SYMDEF	random library
0	lelong	0x39bed	PDP-11 old archive
0	lelong	0x39bee	PDP-11 4.0 archive
0	lelong&0x8080ffff	0x0000081a	ARC archive data, dynamic LZW
0	lelong&0x8080ffff	0x0000091a	ARC archive data, squashed
0	lelong&0x8080ffff	0x0000021a	ARC archive data, uncompressed
0	lelong&0x8080ffff	0x0000031a	ARC archive data, packed
0	lelong&0x8080ffff	0x0000041a	ARC archive data, squeezed
0	lelong&0x8080ffff	0x0000061a	ARC archive data, crunched
0	lelong&0x8080ffff	0x00000a1a	PAK archive data
0	lelong&0x8080ffff	0x0000141a	ARC+ archive data
0	lelong&0x8080ffff	0x0000481a	HYP archive data
0	string	\032archive	RISC OS archive (ArcFS format)
0	string	Archive\000	RISC OS archive (ArcFS format)
0	string	CRUSH Crush archive data
0	string	HLSQZ Squeeze It archive data
0	string	SQWEZ SQWEZ archive data
0	string	HPAK HPack archive data
0	string	\x91\x33HF HAP archive data
0	string	MDmd MDCD archive data
0	string	LIM\x1a LIM archive data
3	string	LH5 SAR archive data
0	string	\212\3SB \0 BSArc/BS2 archive data
2	string	=-ah MAR archive data
0	belong&0x00f800ff	0x00800000 ACB archive data
0	string	JRchive JRC archive data
0	string	DS\0 Quantum archive data
0	string	PK\3\6 ReSOF archive data
0	string	7\4 QuArk archive data
14	string	YC YAC archive data
0	string	X1 X1 archive data
0	string	XhDr X1 archive data
0	belong&0xffffe000	0x76ff2000 CDC Codec archive data
0	string	\xad6" AMGC archive data
0	string	NõFélå NuLIB archive data
0	string	LEOLZW PAKLeo archive data
0	string	SChF ChArc archive data
0	string	PSA PSA archive data
0	string	DSIGDCC CrossePAC archive data
0	string	\x1f\x9f\x4a\x10\x0a Freeze archive data
0	string	¨MP¨ KBoom archive data
0	string	\x76\xff NSQ archive data
0	string	Dirk\ Paehl DPA archive data
0	string	\0\6 TTComp archive data
0	string	ESP ESP archive data
0	string	\1ZPK\1 ZPack archive data
0	string	\xbc\x40 Sky archive data
0	string	UFA UFA archive data
0	string	=-H2O DRY archive data
0	string	FOXSQZ FoxSQZ archive data
0	string	,AR7 AR7 archive data
0	string	PPMZ PPMZ archive data
4	string	\x88\xf0\x27 MS Compress archive data
>9	string	\0	
>>0	string	KWAJ	
>>>7	string	\321\003	MS Compress archive data
>>>>14	ulong	>0	\b, original size: %ld bytes
>>>>18	ubyte	>0x65	
>>>>>18	string	x	\b, was %.8s
>>>>>(10.b-4)	string	x	\b.%.3s
0	string	MP3\x1a MP3-Archiver archive data
0	string	OZÝ ZET archive data
0	string	\x65\x5d\x13\x8c\x08\x01\x03\x00 TSComp archive data
0	string	gW\4\1 ARQ archive data
3	string	OctSqu Squash archive data
0	string	\5\1\1\0 Terse archive data
0	string	\x01\x08\x0b\x08\xef\x00\x9e\x32\x30\x36\x31 PUCrunch archive data
0	string	UHA UHarc archive data
0	string	\2AB ABComp archive data
0	string	\3AB2 ABComp archive data
0	string	CO\0 CMP archive data
0	string	\x93\xb9\x06 Splint archive data
0	string	\x13\x5d\x65\x8c InstallShield Z archive Data
1	string	GTH Gather archive data
0	string	BOA BOA archive data
0	string	ULEB\xa RAX archive data
0	string	ULEB\0 Xtreme archive data
0	string	@â\1\0 Pack Magic archive data
0	belong&0xfeffffff	0x1a034465 BTS archive data
0	string	Ora\	ELI 5750 archive data
0	string	\x1aFC\x1a QFC archive data
0	string	\x1aQF\x1a QFC archive data
0	string	RNC PRO-PACK archive data
0	string	777 777 archive data
0	string	sTaC LZS221 archive data
0	string	HPA HPA archive data
0	string	LG Arhangel archive data
0	string	0123456789012345BZh EXP1 archive data
0	string	IMP\xa IMP archive data
0	string	\x00\x9E\x6E\x72\x76\xFF NRV archive data
0	string	\x73\xb2\x90\xf4 Squish archive data
0	string	PHILIPP Par archive data
0	string	PAR Par archive data
0	string	UB HIT archive data
0	belong&0xfffff000	0x53423000 SBX archive data
0	string	NSK NaShrink archive data
0	string	#\ CAR\ archive\ header SAPCAR archive data
0	string	CAR\ 2.00RG SAPCAR archive data
0	string	DST Disintegrator archive data
0	string	ASD ASD archive data
0	string	ISc( InstallShield CAB
0	string	T4\x1a TOP4 archive data
0	string	BH\5\7 BlakHole archive data
0	string	BIX0 BIX archive data
0	string	ChfLZ ChiefLZA archive data
0	string	Blink Blink archive data
0	string	\xda\xfa Logitech Compress archive data
1	string	(C)\ STEPANYUK ARS-Sfx archive data
0	string	AKT32 AKT32 archive data
0	string	AKT AKT archive data
0	string	MSTSM NPack archive data
0	string	\0\x50\0\x14 PFT archive data
0	string	SEM SemOne archive data
0	string	\x8f\xaf\xac\x84 PPMD archive data
0	string	FIZ FIZ archive data
0	belong&0xfffff0f0	0x4d530000 MSXiE archive data
0	belong&0xfffffff0	0x797a3030 DeepFreezer archive data
0	string	=<DC- DC archive data
0	string	\4TPAC\3 TPac archive data
0	string	Ai\1\1\0 Ai archive data
0	string	Ai\1\0\0 Ai archive data
0	string	Ai\2\0 Ai32 archive data
0	string	Ai\2\1 Ai32 archive data
0	string	SBC SBC archive data
0	string	YBS Ybs archive data
0	string	\x9e\0\0 DitPack archive data
0	string	DMS! DMS archive data
0	string	\x8f\xaf\xac\x8c EPC archive data
0	string	VS\x1a VSARC archive data
0	string	PDZ PDZ archive data
0	string	rdqx ReDuq archive data
0	string	GCAX GCA archive data
0	string	pN PPMN archive data
3	string	WINIMAGE WinImage archive data
0	string	CMP0CMP Compressia archive data
0	string	UHB UHBC archive data
0	string	\x61\x5C\x04\x05 WinHKI archive data
0	string	WWP WWPack archive data
0	string	\xffBSG BSN archive data
1	string	\xffBSG BSN archive data
3	string	\xffBSG BSN archive data
1	string	\0\xae\2 BSN archive data
1	string	\0\xae\3 BSN archive data
1	string	\0\xae\7 BSN archive data
0	string	\x33\x18 AIN archive data
0	string	\x33\x17 AIN archive data
0	string	xpa\0\1 XPA32 archive data
0	string	SZ\x0a\4 SZip archive data
0	string	jm XPack DiskImage archive data
0	string	xpa XPack archive data
0	string	Í\ jm XPack single archive data
0	string	DZ Dzip archive data
>2	byte	x \b, version %i
>3	byte	x \b.%i
0	string	ZZ\ \0\0 ZZip archive data
0	string	ZZ0 ZZip archive data
0	string	\xaa\x40\x5f\x77\x1f\xe5\x82\x0d PAQ archive data
0	string	PAQ PAQ archive data
>3	byte&0xf0	0x30
>>3	byte	x (v%c)
0xe	string	\x1aJar\x1b JAR (ARJ Software, Inc.) archive data
0	string	JARCS JAR (ARJ Software, Inc.) archive data
0	leshort	0xea60	ARJ archive data
>5	byte	x	\b, v%d,
>8	byte	&0x04	multi-volume,
>8	byte	&0x10	slash-switched,
>8	byte	&0x20	backup,
>34	string	x	original name: %s,
>7	byte	0	os: MS-DOS
>7	byte	1	os: PRIMOS
>7	byte	2	os: Unix
>7	byte	3	os: Amiga
>7	byte	4	os: Macintosh
>7	byte	5	os: OS/2
>7	byte	6	os: Apple ][ GS
>7	byte	7	os: Atari ST
>7	byte	8	os: NeXT
>7	byte	9	os: VAX/VMS
>3	byte	>0	%d]
2	leshort	0xea60	ARJ archive data
0	belong&0xffff00fc 0x48410000 HA archive data
>2	leshort	=1	1 file,
>2	leshort	>1	%u files,
>4	byte&0x0f	=0	first is type CPY
>4	byte&0x0f	=1	first is type ASC
>4	byte&0x0f	=2	first is type HSC
>4	byte&0x0f	=0x0e	first is type DIR
>4	byte&0x0f	=0x0f	first is type SPECIAL
0	string	HPAK	HPACK archive data
0	string	\351,\001JAM\	JAM archive,
>7	string	>\0	version %.4s
>0x26	byte	=0x27	-
>>0x2b	string	>\0	label %.11s,
>>0x27	lelong	x	serial %08x,
>>0x36	string	>\0	fstype %.8s
2	string	-lh0-	LHarc 1.x/ARX archive data [lh0]
2	string	-lh1-	LHarc 1.x/ARX archive data [lh1]
2	string	-lz4-	LHarc 1.x archive data [lz4]
2	string	-lz5-	LHarc 1.x archive data [lz5]
2	string	-lzs-	LHa/LZS archive data [lzs]
2	string	-lh\40-	LHa 2.x? archive data [lh ]
2	string	-lhd-	LHa 2.x? archive data [lhd]
2	string	-lh2-	LHa 2.x? archive data [lh2]
2	string	-lh3-	LHa 2.x? archive data [lh3]
2	string	-lh4-	LHa (2.x) archive data [lh4]
2	string	-lh5-	LHa (2.x) archive data [lh5]
2	string	-lh6-	LHa (2.x) archive data [lh6]
2	string	-lh7-	LHa (2.x)/LHark archive data [lh7]
>20	byte	x	- header level %d
2	string	-lZ	PUT archive data
2	string	-lz	LZS archive data 
2	string	-sw1-	Swag archive data
0	string	Rar!	RAR archive data,
>44	byte	x	v%0x,
>35	byte	0	os: MS-DOS
>35	byte	1	os: OS/2
>35	byte	2	os: Win32
>35	byte	3	os: Unix
0	string	RE\x7e\x5e	RAR archive data
0	string	SQSH	squished archive data (Acorn RISCOS)
0	string	UC2\x1a	UC2 archive data
0	string	PK\003\004
>4	byte	0x09	Zip archive data, at least v0.9 to extract
>4	byte	0x0a	Zip archive data, at least v1.0 to extract
>4	byte	0x0b	Zip archive data, at least v1.1 to extract
>4	byte	0x14
>>30	ubelong	!0x6d696d65	Zip archive data, at least v2.0 to extract
>>30	string	mimetype
>>>50	string	vnd.kde.	KOffice (>=1.2)
>>>>58	string	karbon	Karbon document
>>>>58	string	kchart	KChart document
>>>>58	string	kformula	KFormula document
>>>>58	string	kivio	Kivio document
>>>>58	string	kontour	Kontour document
>>>>58	string	kpresenter	KPresenter document
>>>>58	string	kspread	KSpread document
>>>>58	string	kword	KWord document
>>>50	string	vnd.sun.xml.	OpenOffice.org 1.x
>>>>62	string	writer	Writer
>>>>>68	byte	!0x2e	document
>>>>>68	string	.template	template
>>>>>68	string	.global	global document
>>>>62	string	calc	Calc
>>>>>66	byte	!0x2e	spreadsheet
>>>>>66	string	.template	template
>>>>62	string	draw	Draw
>>>>>66	byte	!0x2e	document
>>>>>66	string	.template	template
>>>>62	string	impress	Impress
>>>>>69	byte	!0x2e	presentation
>>>>>69	string	.template	template
>>>>62	string	math	Math document
>>>50	string	vnd.oasis.opendocument.	OpenDocument
>>>>73	string	text
>>>>>77	byte	!0x2d	Text
>>>>>77	string	-template	Text Template
>>>>>77	string	-web	HTML Document Template
>>>>>77	string	-master	Master Document
>>>>73	string	graphics	Drawing
>>>>>81	string	-template	Template
>>>>73	string	presentation	Presentation
>>>>>85	string	-template	Template
>>>>73	string	spreadsheet	Spreadsheet
>>>>>84	string	-template	Template
>>>>73	string	chart	Chart
>>>>>78	string	-template	Template
>>>>73	string	formula	Formula
>>>>>80	string	-template	Template
>>>>73	string	database	Database
>>>>73	string	image	Image
20	lelong	0xfdc4a7dc	Zoo archive data
>4	byte	>48	\b, v%c.
>>6	byte	>47	\b%c
>>>7	byte	>47	\b%c
>32	byte	>0	\b, modify: v%d
>>33	byte	x	\b.%d+
>42	lelong	0xfdc4a7dc	\b,
>>70	byte	>0	extract: v%d
>>>71	byte	x	\b.%d+
10	string	#\ This\ is\ a\ shell\ archive	shell archive text
0	string	\0\ \ \ \ \ \ \ \ \ \ \ \0\0	LBR archive data
2	string	-pm0-	PMarc archive data [pm0]
2	string	-pm1-	PMarc archive data [pm1]
2	string	-pm2-	PMarc archive data [pm2]
2	string	-pms-	PMarc SFX archive (CP/M, DOS)
5	string	-pc1-	PopCom compressed executable (CP/M)
0	leshort	0xeb81	PRCS packaged project
4	string	gtktalog\	GTKtalog catalog data,
>13	string	3	version 3
>>14	beshort	0x677a	(gzipped)
>>14	beshort	!0x677a	(not gzipped)
>13	string	>3	version %s
0	string	PAR\0	PARity archive data
>48	leshort	=0	- Index file
>48	leshort	>0	- file number %d
0	string	d8:announce	BitTorrent file
0	beshort 0x0e0f	Atari MSA archive data
>2	beshort x	\b, %d sectors per track
>4	beshort 0	\b, 1 sided
>4	beshort 1	\b, 2 sided
>6	beshort x	\b, starting track: %d
>8	beshort x	\b, ending track: %d
0	string	PK00PK\003\004	Zip archive data
7	string	**ACE**	ACE archive data
>15	byte	>0	version %d
>16	byte	=0x00	\b, from MS-DOS
>16	byte	=0x01	\b, from OS/2
>16	byte	=0x02	\b, from Win/32
>16	byte	=0x03	\b, from Unix
>16	byte	=0x04	\b, from MacOS
>16	byte	=0x05	\b, from WinNT
>16	byte	=0x06	\b, from Primos
>16	byte	=0x07	\b, from AppleGS
>16	byte	=0x08	\b, from Atari
>16	byte	=0x09	\b, from Vax/VMS
>16	byte	=0x0A	\b, from Amiga
>16	byte	=0x0B	\b, from Next
>14	byte	x	\b, version %d to extract
>5	leshort &0x0080	\b, multiple volumes,
>>17	byte	x	\b (part %d),
>5	leshort &0x0002	\b, contains comment
>5	leshort	&0x0200	\b, sfx
>5	leshort	&0x0400	\b, small dictionary
>5	leshort	&0x0800	\b, multi-volume
>5	leshort	&0x1000	\b, contains AV-String
>>30	string	\x16*UNREGISTERED\x20VERSION*	(unregistered)
>5	leshort &0x2000	\b, with recovery record
>5	leshort &0x4000	\b, locked
>5	leshort &0x8000	\b, solid
0x1A	string	sfArk	sfArk compressed Soundfont
>0x15	string	2
>>0x1	string	>\0	Version %s
>>0x2A	string	>\0	: %s
0	string	Packed\ File\	Personal NetWare Packed File
>12	string	x	\b, was "%.12s"
0	belong	0x1ee7ff00	EET archive
#----------------------------------------------------------------------
# audio:  file(1) magic for sound formats (see also "iff")
# Jan Nicolai Langfeldt (janl@ifi.uio.no), Dan Quinlan (quinlan@yggdrasil.com),
# and others
0	string	.snd	Sun/NeXT audio data:
>12	belong	1	8-bit ISDN mu-law,
>12	belong	2	8-bit linear PCM [REF-PCM],
>12	belong	3	16-bit linear PCM,
>12	belong	4	24-bit linear PCM,
>12	belong	5	32-bit linear PCM,
>12	belong	6	32-bit IEEE floating point,
>12	belong	7	64-bit IEEE floating point,
>12	belong	8	Fragmented sample data,
>12	belong	10	DSP program,
>12	belong	11	8-bit fixed point,
>12	belong	12	16-bit fixed point,
>12	belong	13	24-bit fixed point,
>12	belong	14	32-bit fixed point,
>12	belong	18	16-bit linear with emphasis,
>12	belong	19	16-bit linear compressed,
>12	belong	20	16-bit linear with emphasis and compression,
>12	belong	21	Music kit DSP commands,
>12	belong	23	8-bit ISDN mu-law compressed (CCITT G.721 ADPCM voice data encoding),
>12	belong	24	compressed (8-bit CCITT G.722 ADPCM)
>12	belong	25	compressed (3-bit CCITT G.723.3 ADPCM),
>12	belong	26	compressed (5-bit CCITT G.723.5 ADPCM),
>12	belong	27	8-bit A-law (CCITT G.711),
>20	belong	1	mono,
>20	belong	2	stereo,
>20	belong	4	quad,
>16	belong	>0	%d Hz
0	lelong	0x0064732E	DEC audio data:
>12	lelong	1	8-bit ISDN mu-law,
>12	lelong	2	8-bit linear PCM [REF-PCM],
>12	lelong	3	16-bit linear PCM,
>12	lelong	4	24-bit linear PCM,
>12	lelong	5	32-bit linear PCM,
>12	lelong	6	32-bit IEEE floating point,
>12	lelong	7	64-bit IEEE floating point,
>12	belong	8	Fragmented sample data,
>12	belong	10	DSP program,
>12	belong	11	8-bit fixed point,
>12	belong	12	16-bit fixed point,
>12	belong	13	24-bit fixed point,
>12	belong	14	32-bit fixed point,
>12	belong	18	16-bit linear with emphasis,
>12	belong	19	16-bit linear compressed,
>12	belong	20	16-bit linear with emphasis and compression,
>12	belong	21	Music kit DSP commands,
>12	lelong	23	8-bit ISDN mu-law compressed (CCITT G.721 ADPCM voice data encoding),
>12	belong	24	compressed (8-bit CCITT G.722 ADPCM)
>12	belong	25	compressed (3-bit CCITT G.723.3 ADPCM),
>12	belong	26	compressed (5-bit CCITT G.723.5 ADPCM),
>12	belong	27	8-bit A-law (CCITT G.711),
>20	lelong	1	mono,
>20	lelong	2	stereo,
>20	lelong	4	quad,
>16	lelong	>0	%d Hz
0	string	MThd	Standard MIDI data
>8	beshort	x	(format %d)
>10	beshort	x	using %d track
>10	beshort	>1	\bs
>12	beshort&0x7fff	x	at 1/%d
>12	beshort&0x8000	>0	SMPTE
0	string	CTMF	Creative Music (CMF) data
0	string	SBI	SoundBlaster instrument data
0	string	Creative\ Voice\ File	Creative Labs voice data
>19	byte	0x1A
>23	byte	>0	- version %d
>22	byte	>0	\b.%d
0	belong	0x4e54524b	MultiTrack sound data
>4	belong	x	- version %ld
0	string	EMOD	Extended MOD sound data,
>4	byte&0xf0	x	version %d
>4	byte&0x0f	x	\b.%d,
>45	byte	x	%d instruments
>83	byte	0	(module)
>83	byte	1	(song)
0	belong	0x2e7261fd	RealAudio sound file
0	string	.RMF	RealMedia file
0	string	MAS_U	ULT(imate) Module sound data
0x2c	string	SCRM	ScreamTracker III Module sound data
>0	string	>\0	Title: "%s"
0	string	GF1PATCH110\0ID#000002\0	GUS patch
0	string	GF1PATCH100\0ID#000002\0	Old GUS	patch
0	string	MAS_UTrack_V00
>14	string	>/0	ultratracker V1.%.1s module sound data
0	string	UN05	MikMod UNI format module sound data
0	string	Extended\ Module: Fasttracker II module sound data
>17	string	>\0	Title: "%s"
21	string/c	=!SCREAM!	Screamtracker 2 module sound data
21	string	BMOD2STM	Screamtracker 2 module sound data
1080	string	M.K.	4-channel Protracker module sound data
>0	string	>\0	Title: "%s"
1080	string	M!K!	4-channel Protracker module sound data
>0	string	>\0	Title: "%s"
1080	string	FLT4	4-channel Startracker module sound data
>0	string	>\0	Title: "%s"
1080	string	FLT8	8-channel Startracker module sound data
>0	string	>\0	Title: "%s"
1080	string	4CHN	4-channel Fasttracker module sound data
>0	string	>\0	Title: "%s"
1080	string	6CHN	6-channel Fasttracker module sound data
>0	string	>\0	Title: "%s"
1080	string	8CHN	8-channel Fasttracker module sound data
>0	string	>\0	Title: "%s"
1080	string	CD81	8-channel Octalyser module sound data
>0	string	>\0	Title: "%s"
1080	string	OKTA	8-channel Oktalyzer module sound data
>0	string	>\0	Title: "%s"
1080	string	16CN	16-channel Taketracker module sound data
>0	string	>\0	Title: "%s"
1080	string	32CN	32-channel Taketracker module sound data
>0	string	>\0	Title: "%s"
0	string	TOC	TOC sound file
0	string	SIDPLAY\ INFOFILE	Sidplay info file
0	string	PSID	PlaySID v2.2+ (AMIGA) sidtune
>4	beshort	>0	w/ header v%d,
>14	beshort	=1	single song,
>14	beshort	>1	%d songs,
>16	beshort	>0	default song: %d
>0x16	string	>\0	name: "%s"
>0x36	string	>\0	author: "%s"
>0x56	string	>\0	copyright: "%s"
0	string	RSID	RSID sidtune PlaySID compatible
>4	beshort	>0	w/ header v%d,
>14	beshort	=1	single song,
>14	beshort	>1	%d songs,
>16	beshort	>0	default song: %d
>0x16	string	>\0	name: "%s"
>0x36	string	>\0	author: "%s"
>0x56	string	>\0	copyright: "%s"
0	belong	0x64a30100	IRCAM file (VAX)
0	belong	0x64a30200	IRCAM file (Sun)
0	belong	0x64a30300	IRCAM file (MIPS little-endian)
0	belong	0x64a30400	IRCAM file (NeXT)
0	string	NIST_1A\n\ \ \ 1024\n	NIST SPHERE file
0	string	SOUND\ SAMPLE\ DATA\	Sample Vision file
0	string	2BIT	Audio Visual Research file,
>12	beshort	=0	mono,
>12	beshort	=-1	stereo,
>14	beshort	x	%d bits
>16	beshort	=0	unsigned,
>16	beshort	=-1	signed,
>22	belong&0x00ffffff	x	%d Hz,
>18	beshort	=0	no loop,
>18	beshort	=-1	loop,
>21	ubyte	<=127	note %d,
>22	byte	=0	replay 5.485 KHz
>22	byte	=1	replay 8.084 KHz
>22	byte	=2	replay 10.971 Khz
>22	byte	=3	replay 16.168 Khz
>22	byte	=4	replay 21.942 KHz
>22	byte	=5	replay 32.336 KHz
>22	byte	=6	replay 43.885 KHz
>22	byte	=7	replay 47.261 KHz
0	string	_SGI_SoundTrack	SGI SoundTrack project file
0	string	ID3	Audio file with ID3 version 2
>3	ubyte	<0xff	\b%d.
>4	ubyte	<0xff	\b%d tag
>2584	string	fLaC	\b, FLAC encoding
>>2588 byte&0x7f	>0	\b, unknown version
>>2588 byte&0x7f	0	\b
>>>2600	beshort&0x1f0	0x030	\b, 4 bit
>>>2600	beshort&0x1f0	0x050	\b, 6 bit
>>>2600	beshort&0x1f0	0x070	\b, 8 bit
>>>2600	beshort&0x1f0	0x0b0	\b, 12 bit
>>>2600	beshort&0x1f0	0x0f0	\b, 16 bit
>>>2600	beshort&0x1f0	0x170	\b, 24 bit
>>>2600	byte&0xe	0x0	\b, mono
>>>2600	byte&0xe	0x2	\b, stereo
>>>2600	byte&0xe	0x4	\b, 3 channels
>>>2600	byte&0xe	0x6	\b, 4 channels
>>>2600	byte&0xe	0x8	\b, 5 channels
>>>2600	byte&0xe	0xa	\b, 6 channels
>>>2600	byte&0xe	0xc	\b, 7 channels
>>>2600	byte&0xe	0xe	\b, 8 channels
>>>2597	belong&0xfffff0	0x0ac440	\b, 44.1 kHz
>>>2597	belong&0xfffff0	0x0bb800	\b, 48 kHz
>>>2597	belong&0xfffff0	0x07d000	\b, 32 kHz
>>>2597	belong&0xfffff0	0x056220	\b, 22.05 kHz
>>>2597	belong&0xfffff0	0x05dc00	\b, 24 kHz
>>>2597	belong&0xfffff0	0x03e800	\b, 16 kHz
>>>2597	belong&0xfffff0	0x02b110	\b, 11.025 kHz
>>>2597	belong&0xfffff0	0x02ee00	\b, 12 kHz
>>>2597	belong&0xfffff0	0x01f400	\b, 8 kHz
>>>2597	belong&0xfffff0	0x177000	\b, 96 kHz
>>>2597	belong&0xfffff0	0x0fa000	\b, 64 kHz
>>>2601	byte&0xf	>0	\b, >4G samples
>2584	string	!fLaC	\b, MP3 encoding
0	string	NESM\x1a	NES Sound File
>14	string	>\0	("%s" by
>46	string	>\0	%s, copyright
>78	string	>\0	%s),
>5	byte	x	version %d,
>6	byte	x	%d tracks,
>122	byte&0x2	=1	dual PAL/NTSC
>122	byte&0x1	=1	PAL
>122	byte&0x1	=0	NTSC
0	string	IMPM	Impulse Tracker module sound data -
>4	string	>\0	"%s"
>40	leshort	!0	compatible w/ITv%x
>42	leshort	!0	created w/ITv%x
60	string	IM10	Imago Orpheus module sound data -
>0	string	>\0	"%s"
0	string	IMPS	Impulse Tracker Sample
>18	byte	&2	16 bit
>18	byte	^2	8 bit
>18	byte	&4	stereo
>18	byte	^4	mono
0	string	IMPI	Impulse Tracker Instrument
>28	leshort	!0	ITv%x
>30	byte	!0	%d samples
0	string	LM8953	Yamaha TX Wave
>22	byte	0x49	looped
>22	byte	0xC9	non-looped
>23	byte	1	33kHz
>23	byte	2	50kHz
>23	byte	3	16kHz
76	string	SCRS	Scream Tracker Sample
>0	byte	1	sample
>0	byte	2	adlib melody
>0	byte	>2	adlib drum
>31	byte	&2	stereo
>31	byte	^2	mono
>31	byte	&4	16bit little endian
>31	byte	^4	8bit
>30	byte	0	unpacked
>30	byte	1	packed
0	string	MMD0	MED music file, version 0
0	string	MMD1	OctaMED Pro music file, version 1
0	string	MMD3	OctaMED Soundstudio music file, version 3
0	string	OctaMEDCmpr	OctaMED Soundstudio compressed file
0	string	MED	MED_Song
0	string	SymM	Symphonie SymMOD music file
0	string	THX	AHX version
>3	byte	=0	1 module data
>3	byte	=1	2 module data
0	string	OKTASONG	Oktalyzer module data
0	string	DIGI\ Booster\ module\0	%s
>20	byte	>0	%c
>>21	byte	>0	\b%c
>>>22	byte	>0	\b%c
>>>>23	byte	>0	\b%c
>610	string	>\0	\b, "%s"
0	string	DBM0	DIGI Booster Pro Module
>4	byte	>0	V%X.
>>5	byte	x	\b%02X
>16	string	>\0	\b, "%s"
0	string	FTMN	FaceTheMusic module
>16	string	>\0d	\b, "%s"
0	string	AMShdr\32	Velvet Studio AMS Module v2.2
0	string	Extreme	Extreme Tracker AMS Module v1.3
0	string	DDMF	Xtracker DMF Module
>4	byte	x	v%i
>0xD	string	>\0	Title: "%s"
>0x2B	string	>\0	Composer: "%s"
0	string	DSM\32	Dynamic Studio Module DSM
0	string	SONG	DigiTrekker DTM Module
0	string	DMDL	DigiTrakker MDL Module
0	string	PSM\32	Protracker Studio PSM Module
44	string	PTMF	Poly Tracker PTM Module
>0	string	>\32	Title: "%s"
0	string	MT20	MadTracker 2.0 Module MT2
0	string	RAD\40by\40REALiTY!! RAD Adlib Tracker Module RAD
0	string	RTMM	RTM Module
0x426	string	MaDoKaN96	XMS Adlib Module
>0	string	>\0	Composer: "%s"
0	string	AMF	AMF Module
>4	string	>\0	Title: "%s"
0	string	MODINFO1	Open Cubic Player Module Inforation MDZ
0	string	Extended\40Instrument: Fast Tracker II Instrument
0	string	\210NOA\015\012\032	NOA Nancy Codec Movie file
0	string	MMMD	Yamaha SMAF file
0	string	\001Sharp\040JisakuMelody	SHARP Cell-Phone ringing Melody
>20	string	Ver01.00	Ver. 1.00
>>32	byte	x	, %d tracks
0	string	fLaC	FLAC audio bitstream data
>4	byte&0x7f	>0	\b, unknown version
>4	byte&0x7f	0	\b
>>20	beshort&0x1f0	0x030	\b, 4 bit
>>20	beshort&0x1f0	0x050	\b, 6 bit
>>20	beshort&0x1f0	0x070	\b, 8 bit
>>20	beshort&0x1f0	0x0b0	\b, 12 bit
>>20	beshort&0x1f0	0x0f0	\b, 16 bit
>>20	beshort&0x1f0	0x170	\b, 24 bit
>>20	byte&0xe	0x0	\b, mono
>>20	byte&0xe	0x2	\b, stereo
>>20	byte&0xe	0x4	\b, 3 channels
>>20	byte&0xe	0x6	\b, 4 channels
>>20	byte&0xe	0x8	\b, 5 channels
>>20	byte&0xe	0xa	\b, 6 channels
>>20	byte&0xe	0xc	\b, 7 channels
>>20	byte&0xe	0xe	\b, 8 channels
>>17	belong&0xfffff0	0x0ac440	\b, 44.1 kHz
>>17	belong&0xfffff0	0x0bb800	\b, 48 kHz
>>17	belong&0xfffff0	0x07d000	\b, 32 kHz
>>17	belong&0xfffff0	0x056220	\b, 22.05 kHz
>>17	belong&0xfffff0	0x05dc00	\b, 24 kHz
>>17	belong&0xfffff0	0x03e800	\b, 16 kHz
>>17	belong&0xfffff0	0x02b110	\b, 11.025 kHz
>>17	belong&0xfffff0	0x02ee00	\b, 12 kHz
>>17	belong&0xfffff0	0x01f400	\b, 8 kHz
>>17	belong&0xfffff0	0x177000	\b, 96 kHz
>>17	belong&0xfffff0	0x0fa000	\b, 64 kHz
>>21	byte&0xf	>0	\b, >4G samples
>>21	byte&0xf	0	\b
>>>22	belong	>0	\b, %u samples
>>>22	belong	0	\b, length unknown
0	string	VBOX	VBOX voice message data
8	string	RB40	RBS Song file
>29	string	ReBorn	created by ReBorn
>37	string	Propellerhead	created by ReBirth
0	string	A#S#C#S#S#L#V#3	Synthesizer Generator or Kimwitu data
0	string	A#S#C#S#S#L#HUB	Kimwitu++ data
0	string	TFMX-SONG	TFMX module sound data
0	string	MAC\040	Monkey's Audio compressed format
>4	uleshort	>0x0F8B	version %d
>>(0x08.l)	uleshort	=1000	with fast compression
>>(0x08.l)	uleshort	=2000	with normal compression
>>(0x08.l)	uleshort	=3000	with high compression
>>(0x08.l)	uleshort	=4000	with extra high compression
>>(0x08.l)	uleshort	=5000	with insane compression
>>(0x08.l+18)	uleshort	=1	\b, mono
>>(0x08.l+18)	uleshort	=2	\b, stereo
>>(0x08.l+20)	ulelong	x	\b, sample rate %d
>4	uleshort	<0x0F8C	version %d
>>6	uleshort	=1000	with fast compression
>>6	uleshort	=2000	with normal compression
>>6	uleshort	=3000	with high compression
>>6	uleshort	=4000	with extra high compression
>>6	uleshort	=5000	with insane compression
>>10	uleshort	=1	\b, mono
>>10	uleshort	=2	\b, stereo
>>12	ulelong	x	\b, sample rate %d
0	string	RAWADATA	RdosPlay RAW
1068	string	RoR	AMUSIC Adlib Tracker
0	string	JCH	EdLib
0	string	mpu401tr	MPU-401 Trakker
0	string	SAdT	Surprise! Adlib Tracker
>4	byte	x	Version %d
0	string	XAD!	eXotic ADlib
0	string	ofTAZ!	eXtra Simple Music
0	string	ZXAYEMUL	Spectrum 128 tune
0	string	MP+	Musepack
>3	byte&0x0f	x	SV%d
0	string	\0BONK	BONK,
>14	byte	x	%d channel(s),
>15	byte	=1	lossless,
>15	byte	=0	lossy,
>16	byte	x	mid-side
384	string	LockStream	LockStream Embedded file (mostly MP3 on old Nokia phones)
0	string	TWIN97012000	VQF data
>27	short	0	\b, Mono
>27	short	1	\b, Stereo
>31	short	>0	\b, %d kbit/s
>35	short	>0	\b, %d kHz
0	string	Winamp\ EQ\ library\ file	%s
>23	string	x	\b%.4s
0	string	\[Equalizer\ preset\]	XMMS equalizer preset
0	string	\#EXTM3U	M3U playlist
0	string	\[playlist\]	PLS playlist
1	string	\[licq\]	LICQ configuration file
#----------------------------------------------------------------------
# c-lang:  file(1) magic for C programs (or REXX)
0	string	cscope	cscope reference data
>7	string	x	version %.2s
>7	string	>14
>>10	regex	.+\ -q\	with inverted index
>10	regex	.+\ -c\	text (non-compressed)
#----------------------------------------------------------------------
# commands:  file(1) magic for various shells and interpreters
0	string	:	shell archive or script for antique kernel text
0	string/b	#!\ /bin/sh	Bourne shell script text executable
0	string/b	#!\ /bin/csh	C shell script text executable
0	string/b	#!\ /bin/ksh	Korn shell script text executable
0	string/b	#!\ /bin/tcsh	Tenex C shell script text executable
0	string/b	#!\ /usr/local/tcsh	Tenex C shell script text executable
0	string/b	#!\ /usr/local/bin/tcsh	Tenex C shell script text executable
0	string/b	#!\ /bin/zsh	Paul Falstad's zsh script text executable
0	string/b	#!\ /usr/bin/zsh	Paul Falstad's zsh script text executable
0	string/b	#!\ /usr/local/bin/zsh	Paul Falstad's zsh script text executable
0	string/b	#!\ /usr/local/bin/ash	Neil Brown's ash script text executable
0	string/b	#!\ /usr/local/bin/ae	Neil Brown's ae script text executable
0	string/b	#!\ /bin/nawk	new awk script text executable
0	string/b	#!\ /usr/bin/nawk	new awk script text executable
0	string/b	#!\ /usr/local/bin/nawk	new awk script text executable
0	string/b	#!\ /bin/gawk	GNU awk script text executable
0	string/b	#!\ /usr/bin/gawk	GNU awk script text executable
0	string/b	#!\ /usr/local/bin/gawk	GNU awk script text executable
0	string/b	#!\ /bin/awk	awk script text executable
0	string/b	#!\ /usr/bin/awk	awk script text executable
0	string/b	#!\ /bin/rc	Plan 9 rc shell script text executable
0	string/b	#!\ /bin/bash	Bourne-Again shell script text executable
0	string/b	#!\ /usr/local/bin/bash	Bourne-Again shell script text executable
0	string	#!/usr/bin/env	a
>15	string	>\0	%s script text executable
0	string	#!\ /usr/bin/env	a
>16	string	>\0	%s script text executable
0	string/c	=<?php	PHP script text
0	string	=<?\n	PHP script text
0	string	=<?\r	PHP script text
0	string/b	#!\ /usr/local/bin/php	PHP script text executable
0	string/b	#!\ /usr/bin/php	PHP script text executable
0	string	Zend\x00	PHP script Zend Optimizer data
#----------------------------------------------------------------------
# compress:  file(1) magic for pure-compression formats (no archives)
# compress, gzip, pack, compact, huf, squeeze, crunch, freeze, yabba, etc.
# Formats for various forms of compressed data
# Formats for "compress" proper have been moved into "compress.c",
# because it tries to uncompress it to figure out what's inside.
0	string	\037\235	compress'd data
>2	byte&0x80	>0	block compressed
>2	byte&0x1f	x	%d bits
0	string	\037\213	gzip compressed data
>2	byte	<8	\b, reserved method
>2	byte	>8	\b, unknown method
>3	byte	&0x01	\b, ASCII
>3	byte	&0x02	\b, has CRC
>3	byte	&0x04	\b, extra field
>3	byte&0xC	=0x08
>>10	string	x	\b, was "%s"
>3	byte	&0x10	\b, has comment
>9	byte	=0x00	\b, from FAT filesystem (MS-DOS, OS/2, NT)
>9	byte	=0x01	\b, from Amiga
>9	byte	=0x02	\b, from VMS
>9	byte	=0x03	\b, from Unix
>9	byte	=0x04	\b, from VM/CMS
>9	byte	=0x05	\b, from Atari
>9	byte	=0x06	\b, from HPFS filesystem (OS/2, NT)
>9	byte	=0x07	\b, from MacOS
>9	byte	=0x08	\b, from Z-System
>9	byte	=0x09	\b, from CP/M
>9	byte	=0x0A	\b, from TOPS/20
>9	byte	=0x0B	\b, from NTFS filesystem (NT)
>9	byte	=0x0C	\b, from QDOS
>9	byte	=0x0D	\b, from Acorn RISCOS
>3	byte	&0x10	\b, comment
>3	byte	&0x20	\b, encrypted
>4	ledate	>0	\b, last modified: %s
>8	byte	2	\b, max compression
>8	byte	4	\b, max speed
0	string	\037\036	packed data
>2	belong	>1	\b, %d characters originally
>2	belong	=1	\b, %d character originally
0	short	0x1f1f	old packed data
0	short	0x1fff	compacted data
0	string	\377\037	compacted data
0	short	0145405	huf output
0	string	BZh	bzip2 compressed data
>3	byte	>47	\b, block size = %c00k
0	beshort	0x76FF	squeezed data,
>4	string	x	original name %s
0	beshort	0x76FE	crunched data,
>2	string	x	original name %s
0	beshort	0x76FD	LZH compressed data,
>2	string	x	original name %s
0	string	\037\237	frozen file 2.1
0	string	\037\236	frozen file 1.0 (or gzip 0.5)
0	string	\037\240	SCO compress -H (LZH) data
0	string	BZ	bzip compressed data
>2	byte	x	\b, version: %c
>3	string	=1	\b, compression block size 100k
>3	string	=2	\b, compression block size 200k
>3	string	=3	\b, compression block size 300k
>3	string	=4	\b, compression block size 400k
>3	string	=5	\b, compression block size 500k
>3	string	=6	\b, compression block size 600k
>3	string	=7	\b, compression block size 700k
>3	string	=8	\b, compression block size 800k
>3	string	=9	\b, compression block size 900k
0	string	\x89\x4c\x5a\x4f\x00\x0d\x0a\x1a\x0a	lzop compressed data
>9	beshort	<0x0940
>>9	byte&0xf0	=0x00	- version 0.
>>9	beshort&0x0fff	x	\b%03x,
>>13	byte	1	LZO1X-1,
>>13	byte	2	LZO1X-1(15),
>>13	byte	3	LZO1X-999,
>>14	byte	=0x00	os: MS-DOS
>>14	byte	=0x01	os: Amiga
>>14	byte	=0x02	os: VMS
>>14	byte	=0x03	os: Unix
>>14	byte	=0x05	os: Atari
>>14	byte	=0x06	os: OS/2
>>14	byte	=0x07	os: MacOS
>>14	byte	=0x0A	os: Tops/20
>>14	byte	=0x0B	os: WinNT
>>14	byte	=0x0E	os: Win32
>9	beshort	>0x0939
>>9	byte&0xf0	=0x00	- version 0.
>>9	byte&0xf0	=0x10	- version 1.
>>9	byte&0xf0	=0x20	- version 2.
>>9	beshort&0x0fff	x	\b%03x,
>>15	byte	1	LZO1X-1,
>>15	byte	2	LZO1X-1(15),
>>15	byte	3	LZO1X-999,
>>17	byte	=0x00	os: MS-DOS
>>17	byte	=0x01	os: Amiga
>>17	byte	=0x02	os: VMS
>>17	byte	=0x03	os: Unix
>>17	byte	=0x05	os: Atari
>>17	byte	=0x06	os: OS/2
>>17	byte	=0x07	os: MacOS
>>17	byte	=0x0A	os: Tops/20
>>17	byte	=0x0B	os: WinNT
>>17	byte	=0x0E	os: Win32
0	string	\037\241	Quasijarus strong compressed data
0	string	XPKF	Amiga xpkf.library compressed data
0	string	PP11	Power Packer 1.1 compressed data
0	string	PP20	Power Packer 2.0 compressed data,
>4	belong	0x09090909	fast compression
>4	belong	0x090A0A0A	mediocre compression
>4	belong	0x090A0B0B	good compression
>4	belong	0x090A0C0C	very good compression
>4	belong	0x090A0C0D	best compression
0	string	7z\274\257\047\034	7-zip archive data,
>6	byte	x	version %d
>7	byte	x	\b.%d
2	string	-afx-	AFX compressed file data
0	string	RZIP	rzip compressed data
>4	byte	x	- version %d
>5	byte	x	\b.%d
>6	belong	x	(%d bytes)
#----------------------------------------------------------------------
# flash:	file(1) magic for Macromedia Flash file format
# See
#	http://www.macromedia.com/software/flash/open/
0	string	FWS	Macromedia Flash data,
>3	byte	x	version %d
0	string	CWS	Macromedia Flash data (compressed),
>3	byte	x	version %d
0	string	FLV	Macromedia Flash Video
0	string AGD4\xbe\xb8\xbb\xcb\x00	Macromedia Freehand 9 Document
#----------------------------------------------------------------------
# iff:	file(1) magic for Interchange File Format (see also "audio" & "images")
# Daniel Quinlan (quinlan@yggdrasil.com) -- IFF was designed by Electronic
# Arts for file interchange.	It has also been used by Apple, SGI, and
# especially Commodore-Amiga.
# IFF files begin with an 8 byte FORM header, followed by a 4 character
# FORM type, which is followed by the first chunk in the FORM.
0	string	FORM	IFF data
>8	string	AIFF	\b, AIFF audio
>8	string	AIFC	\b, AIFF-C compressed audio
>8	string	8SVX	\b, 8SVX 8-bit sampled sound voice
>8	string	16SV	\b, 16SV 16-bit sampled sound voice
>8	string	SAMP	\b, SAMP sampled audio
>8	string	MAUD	\b, MAUD MacroSystem audio
>8	string	SMUS	\b, SMUS simple music
>8	string	CMUS	\b, CMUS complex music
>8	string	ILBMBMHD	\b, ILBM interleaved image
>>20	beshort	x	\b, %d x
>>22	beshort	x	%d
>8	string	RGBN	\b, RGBN 12-bit RGB image
>8	string	RGB8	\b, RGB8 24-bit RGB image
>8	string	DEEP	\b, DEEP TVPaint/XiPaint image
>8	string	DR2D	\b, DR2D 2-D object
>8	string	TDDD	\b, TDDD 3-D rendering
>8	string	LWOB	\b, LWOB 3-D object
>8	string	LWO2	\b, LWO2 3-D object, v2
>8	string	LWLO	\b, LWLO 3-D layered object
>8	string	REAL	\b, REAL Real3D rendering
>8	string	MC4D	\b, MC4D MaxonCinema4D rendering
>8	string	ANIM	\b, ANIM animation
>8	string	YAFA	\b, YAFA animation
>8	string	SSA\	\b, SSA super smooth animation
>8	string	ACBM	\b, ACBM continuous image
>8	string	FAXX	\b, FAXX fax image
>8	string	FTXT	\b, FTXT formatted text
>8	string	CTLG	\b, CTLG message catalog
>8	string	PREF	\b, PREF preferences
>8	string	DTYP	\b, DTYP datatype description
>8	string	PTCH	\b, PTCH binary patch
>8	string	AMFF	\b, AMFF AmigaMetaFile format
>8	string	WZRD	\b, WZRD StormWIZARD resource
>8	string	DOC\	\b, DOC desktop publishing document
>8	string	IFRS	\b, Blorb Interactive Fiction
>>24	string	Exec	with executable chunk
>8	string	IFZS	\b, Z-machine or Glulx saved game file (Quetzal)
#----------------------------------------------------------------------
# images:  file(1) magic for image formats (see also "iff")
# originally from jef@helios.ee.lbl.gov (Jef Poskanzer),
# additions by janl@ifi.uio.no as well as others. Jan also suggested
# merging several one- and two-line files into here.
# little magic: PCX (first byte is 0x0a)
1	belong&0xfff7ffff	0x01010000	Targa image data - Map
>2	byte&8	8	- RLE
>12	leshort	>0	%hd x
>14	leshort	>0	%hd
1	belong&0xfff7ffff	0x00020000	Targa image data - RGB
>2	byte&8	8	- RLE
>12	leshort	>0	%hd x
>14	leshort	>0	%hd
1	belong&0xfff7ffff	0x00030000	Targa image data - Mono
>2	byte&8	8	- RLE
>12	leshort	>0	%hd x
>14	leshort	>0	%hd
0	string	P1	Netpbm PBM image text
0	string	P2	Netpbm PGM image text
0	string	P3	Netpbm PPM image text
0	string	P4	Netpbm PBM "rawbits" image data
0	string	P5	Netpbm PGM "rawbits" image data
0	string	P6	Netpbm PPM "rawbits" image data
0	string	P7	Netpbm PAM image file
0	string	\117\072	Solitaire Image Recorder format
>4	string	\013	MGI Type 11
>4	string	\021	MGI Type 17
0	string	.MDA	MicroDesign data
>21	byte	48	version 2
>21	byte	51	version 3
0	string	.MDP	MicroDesign page data
>21	byte	48	version 2
>21	byte	51	version 3
0	string	IIN1	NIFF image data
0	string	MM\x00\x2a	TIFF image data, big-endian
0	string	II\x2a\x00	TIFF image data, little-endian
0	string	\x89PNG	PNG image data,
>4	belong	!0x0d0a1a0a	CORRUPTED,
>4	belong	0x0d0a1a0a
>>16	belong	x	%ld x
>>20	belong	x	%ld,
>>24	byte	x	%d-bit
>>25	byte	0	grayscale,
>>25	byte	2	\b/color RGB,
>>25	byte	3	colormap,
>>25	byte	4	gray+alpha,
>>25	byte	6	\b/color RGBA,
>>28	byte	0	non-interlaced
>>28	byte	1	interlaced
1	string	PNG	PNG image data, CORRUPTED
0	string	GIF8	GIF image data
>4	string	7a	\b, version 8%s,
>4	string	9a	\b, version 8%s,
>6	leshort	>0	%hd x
>8	leshort	>0	%hd
0	string	\361\0\100\273	CMU window manager raster image data
>4	lelong	>0	%d x
>8	lelong	>0	%d,
>12	lelong	>0	%d-bit
0	string	id=ImageMagick	MIFF image data
0	long	1123028772	Artisan image data
>4	long	1	\b, rectangular 24-bit
>4	long	2	\b, rectangular 8-bit with colormap
>4	long	3	\b, rectangular 32-bit (24-bit with matte)
0	string	#FIG	FIG image text
>5	string	x	\b, version %.3s
0	string	ARF_BEGARF	PHIGS clear text archive
0	string	@(#)SunPHIGS	SunPHIGS
>40	string	SunBin	binary
>32	string	archive	archive
0	string	GKSM	GKS Metafile
>24	string	SunGKS	\b, SunGKS
0	string	BEGMF	clear text Computer Graphics Metafile
0	beshort&0xffe0	0x0020	binary Computer Graphics Metafile
0	beshort	0x3020	character Computer Graphics Metafile
0	string	yz	MGR bitmap, modern format, 8-bit aligned
0	string	zz	MGR bitmap, old format, 1-bit deep, 16-bit aligned
0	string	xz	MGR bitmap, old format, 1-bit deep, 32-bit aligned
0	string	yx	MGR bitmap, modern format, squeezed
0	string	%bitmap\0	FBM image data
>30	long	0x31	\b, mono
>30	long	0x33	\b, color
1	string	PC\ Research,\ Inc	group 3 fax data
>29	byte	0	\b, normal resolution (204x98 DPI)
>29	byte	1	\b, fine resolution (204x196 DPI)
0	string	Sfff	structured fax file
0	string	BM	PC bitmap data
>14	leshort	12	\b, OS/2 1.x format
>>18	leshort	x	\b, %d x
>>20	leshort	x	%d
>14	leshort	64	\b, OS/2 2.x format
>>18	leshort	x	\b, %d x
>>20	leshort	x	%d
>14	leshort	40	\b, Windows 3.x format
>>18	lelong	x	\b, %d x
>>22	lelong	x	%d x
>>28	leshort	x	%d
0	string	/*\ XPM\ */	X pixmap image text
0	leshort	0xcc52	RLE image data,
>6	leshort	x	%d x
>8	leshort	x	%d
>2	leshort	>0	\b, lower left corner: %d
>4	leshort	>0	\b, lower right corner: %d
>10	byte&0x1	=0x1	\b, clear first
>10	byte&0x2	=0x2	\b, no background
>10	byte&0x4	=0x4	\b, alpha channel
>10	byte&0x8	=0x8	\b, comment
>11	byte	>0	\b, %d color channels
>12	byte	>0	\b, %d bits per pixel
>13	byte	>0	\b, %d color map channels
0	string	Imagefile\ version-	iff image data
>10	string	>\0	%s
0	belong	0x59a66a95	Sun raster image data
>4	belong	>0	\b, %d x
>8	belong	>0	%d,
>12	belong	>0	%d-bit,
>20	belong	0	old format,
>20	belong	2	compressed,
>20	belong	3	RGB,
>20	belong	4	TIFF,
>20	belong	5	IFF,
>20	belong	0xffff	reserved for testing,
>24	belong	0	no colormap
>24	belong	1	RGB colormap
>24	belong	2	raw colormap
0	beshort	474	SGI image data
>2	byte	1	\b, RLE
>3	byte	2	\b, high precision
>4	beshort	x	\b, %d-D
>6	beshort	x	\b, %d x
>8	beshort	x	%d
>10	beshort	x	\b, %d channel
>10	beshort	!1	\bs
>80	string	>0	\b, "%s"
0	string	IT01	FIT image data
>4	belong	x	\b, %d x
>8	belong	x	%d x
>12	belong	x	%d
0	string	IT02	FIT image data
>4	belong	x	\b, %d x
>8	belong	x	%d x
>12	belong	x	%d
2048	string	PCD_IPI	Kodak Photo CD image pack file
>0xe02	byte&0x03	0x00	, landscape mode
>0xe02	byte&0x03	0x01	, portrait mode
>0xe02	byte&0x03	0x02	, landscape mode
>0xe02	byte&0x03	0x03	, portrait mode
0	string	PCD_OPA	Kodak Photo CD overview pack file
0	string	SIMPLE\ \ =	FITS image data
>109	string	8	\b, 8-bit, character or unsigned binary integer
>108	string	16	\b, 16-bit, two's complement binary integer
>107	string	\ 32	\b, 32-bit, two's complement binary integer
>107	string	-32	\b, 32-bit, floating point, single precision
>107	string	-64	\b, 64-bit, floating point, double precision
0	string	This\ is\ a\ BitMap\ file	Lisp Machine bit-array-file
0	string	=!!	Bennet Yee's "face" format
0	beshort	0x1010	PEX Binary Archive
03000	string	Visio\ (TM)\ Drawing	%s
0	string	\%TGIF\ x	Tgif file version %s
128	string	DICM	DICOM medical imaging data
4	belong	7	XWD X Window Dump image data
>100	string	>\0	\b, "%s"
>16	belong	x	\b, %dx
>20	belong	x	\b%dx
>12	belong	x	\b%d
0	string	NJPL1I00	PDS (JPL) image data
2	string	NJPL1I	PDS (JPL) image data
0	string	CCSD3ZF	PDS (CCSD) image data
2	string	CCSD3Z	PDS (CCSD) image data
0	string	PDS_	PDS image data
0	string	LBLSIZE=	PDS (VICAR) image data
0	string	pM85	Atari ST STAD bitmap image data (hor)
>5	byte	0x00	(white background)
>5	byte	0xFF	(black background)
0	string	pM86	Atari ST STAD bitmap image data (vert)
>5	byte	0x00	(white background)
>5	byte	0xFF	(black background)
#----------------------------------------------------------------------
# JPEG images
# SunOS 5.5.1 had
#	0	string	\377\330\377\340	JPEG file
#	0	string	\377\330\377\356	JPG file
# both of which turn into "JPEG image data" here.
0	beshort	0xffd8	JPEG image data
>6	string	JFIF	\b, JFIF standard
>>11	byte	x	\b %d.
>>12	byte	x	\b%02d
>>18	byte	!0	\b, thumbnail %dx
>>>19	byte	x	\b%d
>6	string	Exif	\b, EXIF standard
>>12	string	II	
>>>70	leshort	0x8769	
>>>>(78.l+14)	leshort	0x9000	
>>>>>(78.l+23)	byte	x	%c
>>>>>(78.l+24)	byte	x	\b.%c
>>>>>(78.l+25)	byte	!0x30	\b%c
>>>118	leshort	0x8769	
>>>>(126.l+38)	leshort	0x9000	
>>>>>(126.l+47)	byte	x	%c
>>>>>(126.l+48)	byte	x	\b.%c
>>>>>(126.l+49)	byte	!0x30	\b%c
>>>130	leshort	0x8769	
>>>>(138.l+38)	leshort	0x9000	
>>>>>(138.l+47)	byte	x	%c
>>>>>(138.l+48)	byte	x	\b.%c
>>>>>(138.l+49)	byte	!0x30	\b%c
>>>>(138.l+50)	leshort	0x9000	
>>>>>(138.l+59)	byte	x	%c
>>>>>(138.l+60)	byte	x	\b.%c
>>>>>(138.l+61)	byte	!0x30	\b%c
>>>>(138.l+62)	leshort	0x9000	
>>>>>(138.l+71)	byte	x	%c
>>>>>(138.l+72)	byte	x	\b.%c
>>>>>(138.l+73)	byte	!0x30	\b%c
>>>142	leshort	0x8769	
>>>>(150.l+38)	leshort	0x9000	
>>>>>(150.l+47)	byte	x	%c
>>>>>(150.l+48)	byte	x	\b.%c
>>>>>(150.l+49)	byte	!0x30	\b%c
>>>>(150.l+50)	leshort	0x9000	
>>>>>(150.l+59)	byte	x	%c
>>>>>(150.l+60)	byte	x	\b.%c
>>>>>(150.l+61)	byte	!0x30	\b%c
>>>>(150.l+62)	leshort	0x9000	
>>>>>(150.l+71)	byte	x	%c
>>>>>(150.l+72)	byte	x	\b.%c
>>>>>(150.l+73)	byte	!0x30	\b%c
>>12	string	MM	
>>>118	beshort	0x8769	
>>>>(126.L+14)	beshort	0x9000	
>>>>>(126.L+23)	byte	x	%c
>>>>>(126.L+24)	byte	x	\b.%c
>>>>>(126.L+25)	byte	!0x30	\b%c
>>>>(126.L+38)	beshort	0x9000	
>>>>>(126.L+47)	byte	x	%c
>>>>>(126.L+48)	byte	x	\b.%c
>>>>>(126.L+49)	byte	!0x30	\b%c
>>>130	beshort	0x8769	
>>>>(138.L+38)	beshort	0x9000	
>>>>>(138.L+47)	byte	x	%c
>>>>>(138.L+48)	byte	x	\b.%c
>>>>>(138.L+49)	byte	!0x30	\b%c
>>>>(138.L+62)	beshort	0x9000	
>>>>>(138.L+71)	byte	x	%c
>>>>>(138.L+72)	byte	x	\b.%c
>>>>>(138.L+73)	byte	!0x30	\b%c
>>>142	beshort	0x8769	
>>>>(150.L+50)	beshort	0x9000	
>>>>>(150.L+59)	byte	x	%c
>>>>>(150.L+60)	byte	x	\b.%c
>>>>>(150.L+61)	byte	!0x30	\b%c
>(4.S+5)	byte	0xFE
>>(4.S+8)	string	>\0	\b, comment: "%s"
>(4.S+5)	byte	0xC0	\b, baseline
>>(4.S+6)	byte	x	\b, precision %d
>>(4.S+7)	beshort	x	\b, %dx
>>(4.S+9)	beshort	x	\b%d
>(4.S+5)	byte	0xC1	\b, extended sequential
>>(4.S+6)	byte	x	\b, precision %d
>>(4.S+7)	beshort	x	\b, %dx
>>(4.S+9)	beshort	x	\b%d
>(4.S+5)	byte	0xC2	\b, progressive
>>(4.S+6)	byte	x	\b, precision %d
>>(4.S+7)	beshort	x	\b, %dx
>>(4.S+9)	beshort	x	\b%d
0	string	hsi1	JPEG image data, HSI proprietary
0	string	\x00\x00\x00\x0C\x6A\x50\x20\x20\x0D\x0A\x87\x0A	JPEG 2000 image data
#----------------------------------------------------------------------
# lisp:  file(1) magic for lisp programs
# various lisp types, from Daniel Quinlan (quinlan@yggdrasil.com)
0	string	;;	
>2	search/2048	!\r	Lisp/Scheme program text
>2	search/2048	\r	Windows INF file
0	string	(	
>1	string	if\	Lisp/Scheme program text
>1	string	setq\	Lisp/Scheme program text
>1	string	defvar\	Lisp/Scheme program text
>1	string	autoload\	Lisp/Scheme program text
>1	string	custom-set-variables	Lisp/Scheme program text
0	string	\012(	Emacs v18 byte-compiled Lisp data
0	string	;ELC	
>4	byte	>19	
>4	byte	<32	Emacs/XEmacs v%d byte-compiled Lisp data
0	string	(SYSTEM::VERSION\040'	CLISP byte-compiled Lisp program text
0	long	0x70768BD2	CLISP memory image data
0	long	0xD28B7670	CLISP memory image data, other endian
0	long	0xDE120495	GNU-format message catalog data
0	long	0x950412DE	GNU-format message catalog data
0	string	\372\372\372\372	MIT scheme (library?)
0	string	\<TeXmacs|	TeXmacs document text
#----------------------------------------------------------------------
# macintosh description
# BinHex is the Macintosh ASCII-encoded file format (see also "apple")
# Daniel Quinlan, quinlan@yggdrasil.com
11	string	must\ be\ converted\ with\ BinHex	BinHex binary text
>41	string	x	\b, version %.3s
0	string	SIT!	StuffIt Archive (data)
>2	string	x	: %s
0	string	SITD	StuffIt Deluxe (data)
>2	string	x	: %s
0	string	Seg	StuffIt Deluxe Segment (data)
>2	string	x	: %s
0	string	StuffIt	StuffIt Archive
0	string	APPL	Macintosh Application (data)
>2	string	x	\b: %s
0	string	zsys	Macintosh System File (data)
0	string	FNDR	Macintosh Finder (data)
0	string	libr	Macintosh Library (data)
>2	string	x	: %s
0	string	shlb	Macintosh Shared Library (data)
>2	string	x	: %s
0	string	cdev	Macintosh Control Panel (data)
>2	string	x	: %s
0	string	INIT	Macintosh Extension (data)
>2	string	x	: %s
0	string	FFIL	Macintosh Truetype Font (data)
>2	string	x	: %s
0	string	LWFN	Macintosh Postscript Font (data)
>2	string	x	: %s
0	string	PACT	Macintosh Compact Pro Archive (data)
>2	string	x	: %s
0	string	ttro	Macintosh TeachText File (data)
>2	string	x	: %s
0	string	TEXT	Macintosh TeachText File (data)
>2	string	x	: %s
0	string	PDF	Macintosh PDF File (data)
>2	string	x	: %s
102	string	mBIN	MacBinary III data with surprising version number
0	string	SAS	SAS
>24	string	DATA	data file
>24	string	CATALOG	catalog
>24	string	INDEX	data file index
>24	string	VIEW	data view
0x54	string	SAS	SAS 7+
>0x9C	string	DATA	data file
>0x9C	string	CATALOG	catalog
>0x9C	string	INDEX	data file index
>0x9C	string	VIEW	data view
0	long	0xc1e2c3c9	SPSS Portable File
>40	string	x	%s
0	string	$FL2	SPSS System File
>24	string	x	%s
0x400	beshort	0xD2D7	Macintosh MFS data
>0	beshort	0x4C4B	(bootable)
>0x40a	beshort	&0x8000	(locked)
>0x402	beldate-0x7C25B080	x	created: %s,
>0x406	beldate-0x7C25B080	>0	last backup: %s,
>0x414	belong	x	block size: %d,
>0x412	beshort	x	number of blocks: %d,
>0x424	pstring	x	volume name: %s
0x400	beshort	0x482B	Macintosh HFS Extended
>&0	beshort	x	version %d data
>0	beshort	0x4C4B	(bootable)
>0x404	belong	^0x00000100	(mounted)
>&2	belong	&0x00000200	(spared blocks)
>&2	belong	&0x00000800	(unclean)
>&2	belong	&0x00008000	(locked)
>&6	string	x	last mounted by: '%.4s',
>&14	beldate-0x7C25B080	x	created: %s,
>&18	bedate-0x7C25B080	x	last modified: %s,
>&22	bedate-0x7C25B080	>0	last backup: %s,
>&26	bedate-0x7C25B080	>0	last checked: %s,
>&38	belong	x	block size: %d,
>&42	belong	x	number of blocks: %d,
>&46	belong	x	free blocks: %d
0x200	beshort	0x504D	Apple Partition data
>0x2	beshort	x	block size: %d,
>0x230	string	x	first type: %s,
>0x210	string	x	name: %s,
>0x254	belong	x	number of blocks: %d,
>0x400	beshort	0x504D	
>>0x430	string	x	second type: %s,
>>0x410	string	x	name: %s,
>>0x454	belong	x	number of blocks: %d,
>>0x800	beshort	0x504D	
>>>0x830	string	x	third type: %s,
>>>0x810	string	x	name: %s,
>>>0x854	belong	x	number of blocks: %d,
>>>0xa00	beshort	0x504D	
>>>>0xa30	string	x	fourth type: %s,
>>>>0xa10	string	x	name: %s,
>>>>0xa54	belong	x	number of blocks: %d
0x200	beshort	0x5453	Apple Old Partition data
>0x2	beshort	x	block size: %d,
>0x230	string	x	first type: %s,
>0x210	string	x	name: %s,
>0x254	belong	x	number of blocks: %d,
>0x400	beshort	0x504D	
>>0x430	string	x	second type: %s,
>>0x410	string	x	name: %s,
>>0x454	belong	x	number of blocks: %d,
>>0x800	beshort	0x504D	
>>>0x830	string	x	third type: %s,
>>>0x810	string	x	name: %s,
>>>0x854	belong	x	number of blocks: %d,
>>>0xa00	beshort	0x504D	
>>>>0xa30	string	x	fourth type: %s,
>>>>0xa10	string	x	name: %s,
>>>>0xa54	belong	x	number of blocks: %d
0	string	BOMStore	Mac OS X bill of materials (BOM) fil
#----------------------------------------------------------------------
# mime:  file(1) magic for MIME encoded files
0	string	Content-Type:\
>14	string	>\0	%s
0	string	Content-Type:
>13	string	>\0	%s
#----------------------------------------------------------------------
# modem:  file(1) magic for modem programs
# From: Florian La Roche <florian@knorke.saar.de>
4	string	Research,	Digifax-G3-File
>29	byte	1	, fine resolution
>29	byte	0	, normal resolution
0	short	0x0100	raw G3 data, byte-padded
0	short	0x1400	raw G3 data
0	string	RMD1	raw modem data
>4	string	>\0	(%s /
>20	short	>0	compression type 0x%04x)
0	string	PVF1\n	portable voice format
>5	string	>\0	(binary %s)
0	string	PVF2\n	portable voice format
>5	string >\0	(ascii %s)
#----------------------------------------------------------------------
# msdos:  file(1) magic for MS-DOS files
0	string	@	
>1	string/cB	\ echo\ off	MS-DOS batch file text
>1	string/cB	echo\ off	MS-DOS batch file text
>1	string/cB	rem\	MS-DOS batch file text
>1	string/cB	set\	MS-DOS batch file text
100 regex/c =^\\s*call\s+rxfuncadd.*sysloadfu OS/2 REXX batch file text
100 regex/c =^\\s*say\ ['"] OS/2 REXX batch file text
0	leshort	0x14c	MS Windows COFF Intel 80386 object file
0	leshort	0x166	MS Windows COFF MIPS R4000 object file
0	leshort	0x184	MS Windows COFF Alpha object file
0	leshort	0x268	MS Windows COFF Motorola 68000 object file
0	leshort	0x1f0	MS Windows COFF PowerPC object file
0	leshort	0x290	MS Windows COFF PA-RISC object file
0	string	MZ
>0x18	leshort <0x40 MS-DOS executable
>0 string MZ\0\0\0\0\0\0\0\0\0\0PE\0\0 \b, PE for MS Windows
>>&18	leshort&0x2000	>0	(DLL)
>>&88	leshort	0	(unknown subsystem)
>>&88	leshort	1	(native)
>>&88	leshort	2	(GUI)
>>&88	leshort	3	(console)
>>&88	leshort	7	(POSIX)
>>&0	leshort	0x0	unknown processor
>>&0	leshort	0x14c	Intel 80386
>>&0	leshort	0x166	MIPS R4000
>>&0	leshort	0x184	Alpha
>>&0	leshort	0x268	Motorola 68000
>>&0	leshort	0x1f0	PowerPC
>>&0	leshort	0x290	PA-RISC
>>&18	leshort&0x0100	>0	32-bit
>>&18	leshort&0x1000	>0	system file
>>&0xf4 search/0x140 \x0\x40\x1\x0
>>>(&0.l+(4)) string MSCF \b, WinHKI CAB self-extracting archive
>0x18	leshort >0x3f
>>(0x3c.l) string PE\0\0 PE
>>>(0x3c.l+25) byte	1 \b32 executable
>>>(0x3c.l+25) byte	2 \b32+ executable
>>>(0x3c.l+92)	leshort	<10
>>>>(8.s*16) string 32STUB for MS-DOS, 32rtm DOS extender
>>>>(8.s*16) string !32STUB for MS Windows
>>>>>(0x3c.l+22)	leshort&0x2000	>0	(DLL)
>>>>>(0x3c.l+92)	leshort	0	(unknown subsystem)
>>>>>(0x3c.l+92)	leshort	1	(native)
>>>>>(0x3c.l+92)	leshort	2	(GUI)
>>>>>(0x3c.l+92)	leshort	3	(console)
>>>>>(0x3c.l+92)	leshort	7	(POSIX)
>>>(0x3c.l+92)	leshort	10	(EFI application)
>>>(0x3c.l+92)	leshort	11	(EFI boot service driver)
>>>(0x3c.l+92)	leshort	12	(EFI runtime driver)
>>>(0x3c.l+4)	leshort	0x0	unknown processor
>>>(0x3c.l+4)	leshort	0x14c	Intel 80386
>>>(0x3c.l+4)	leshort	0x166	MIPS R4000
>>>(0x3c.l+4)	leshort	0x184	Alpha
>>>(0x3c.l+4)	leshort	0x268	Motorola 68000
>>>(0x3c.l+4)	leshort	0x1f0	PowerPC
>>>(0x3c.l+4)	leshort	0x290	PA-RISC
>>>(0x3c.l+4)	leshort	0x200	Intel Itanium
>>>(0x3c.l+22)	leshort&0x0100	>0	32-bit
>>>(0x3c.l+22)	leshort&0x1000	>0	system file
>>>>(0x3c.l+0xf8)	string	UPX0 \b, UPX compressed
>>>>(0x3c.l+0xf8)	search/0x140	PEC2 \b, PECompact2 compressed
>>>>(0x3c.l+0xf8)	search/0x140	UPX2
>>>>>(&0x10.l+(-4))	string	PK\3\4 \b, ZIP self-extracting archive (Info-Zip)
>>>>(0x3c.l+0xf8)	search/0x140	.idata
>>>>>(&0xe.l+(-4))	string	PK\3\4 \b, ZIP self-extracting archive (Info-Zip)
>>>>>(&0xe.l+(-4))	string	ZZ0 \b, ZZip self-extracting archive
>>>>>(&0xe.l+(-4))	string	ZZ1 \b, ZZip self-extracting archive
>>>>(0x3c.l+0xf8)	search/0x140	.rsrc
>>>>>(&0x0f.l+(-4))	string	a\\\4\5 \b, WinHKI self-extracting archive
>>>>>(&0x0f.l+(-4))	string	Rar! \b, RAR self-extracting archive
>>>>>(&0x0f.l+(-4))	search/0x3000	MSCF \b, InstallShield self-extracting archive
>>>>>(&0x0f.l+(-4))	search/32	Nullsoft \b, Nullsoft Installer self-extracting archive
>>>>(0x3c.l+0xf8)	search/0x140	.data
>>>>>(&0x0f.l)	string	WEXTRACT \b, MS CAB-Installer self-extracting archive
>>>>(0x3c.l+0xf8)	search/0x140	.petite\0 \b, Petite compressed
>>>>>(0x3c.l+0xf7)	byte	x
>>>>>>(&0x104.l+(-4))	string	=!sfx! \b, ACE self-extracting archive
>>>>(0x3c.l+0xf8)	search/0x140	.WISE \b, WISE installer self-extracting archive
>>>>(0x3c.l+0xf8)	search/0x140	.dz\0\0\0 \b, Dzip self-extracting archive
>>>>(0x3c.l+0xf8)	search/0x140	.reloc
>>>>>(&0xe.l+(-4))	search/0x180	PK\3\4 \b, ZIP self-extracting archive (WinZip)
>>>>&(0x3c.l+0xf8)	search/0x100	_winzip_ \b, ZIP self-extracting archive (WinZip)
>>>>&(0x3c.l+0xf8)	search/0x100	SharedD \b, Microsoft Installer self-extracting archive
>>>>0x30	string	Inno \b, InnoSetup self-extracting archive
>>(0x3c.l) string !PE\0\0 MS-DOS executable
>>(0x3c.l)	string	NE \b, NE
>>>(0x3c.l+0x36)	byte	0 (unknown OS)
>>>(0x3c.l+0x36)	byte	1 for OS/2 1.x
>>>(0x3c.l+0x36)	byte	2 for MS Windows 3.x
>>>(0x3c.l+0x36)	byte	3 for MS-DOS
>>>(0x3c.l+0x36)	byte	>3 (unknown OS)
>>>(0x3c.l+0x36)	byte	0x81 for MS-DOS, Phar Lap DOS extender
>>>(0x3c.l+0x0c)	leshort&0x8003	0x8002 (DLL)
>>>(0x3c.l+0x0c)	leshort&0x8003	0x8001 (driver)
>>>&(&0x24.s-1)	string	ARJSFX \b, ARJ self-extracting archive
>>>(0x3c.l+0x70)	search/0x80	WinZip(R)\ Self-Extractor \b, ZIP self-extracting archive (WinZip)
>>(0x3c.l)	string	LX\0\0 \b, LX
>>>(0x3c.l+0x0a)	leshort	<1 (unknown OS)
>>>(0x3c.l+0x0a)	leshort	1 for OS/2
>>>(0x3c.l+0x0a)	leshort	2 for MS Windows
>>>(0x3c.l+0x0a)	leshort	3 for DOS
>>>(0x3c.l+0x0a)	leshort	>3 (unknown OS)
>>>(0x3c.l+0x10)	lelong&0x28000	=0x8000 (DLL)
>>>(0x3c.l+0x10)	lelong&0x20000	>0 (device driver)
>>>(0x3c.l+0x10)	lelong&0x300	0x300 (GUI)
>>>(0x3c.l+0x10)	lelong&0x28300	<0x300 (console)
>>>(0x3c.l+0x08)	leshort	1 i80286
>>>(0x3c.l+0x08)	leshort	2 i80386
>>>(0x3c.l+0x08)	leshort	3 i80486
>>>(8.s*16)	string	emx \b, emx
>>>>&1	string	x %s
>>>&(&0x54.l-3)	string	arjsfx \b, ARJ self-extracting archive
>>(0x3c.l)	string	W3 \b, W3 for MS Windows
>>(0x3c.l)	string	LE\0\0 \b, LE executable
>>>(0x3c.l+0x0a)	leshort	1
>>>>0x240	search/0x100	DOS/4G for MS-DOS, DOS4GW DOS extender
>>>>0x240	search/0x200	WATCOM\ C/C++ for MS-DOS, DOS4GW DOS extender
>>>>0x440	search/0x100	CauseWay\ DOS\ Extender for MS-DOS, CauseWay DOS extender
>>>>0x40	search/0x40	PMODE/W for MS-DOS, PMODE/W DOS extender
>>>>0x40	search/0x40	STUB/32A for MS-DOS, DOS/32A DOS extender (stub)
>>>>0x40	search/0x80	STUB/32C for MS-DOS, DOS/32A DOS extender (configurable stub)
>>>>0x40	search/0x80	DOS/32A for MS-DOS, DOS/32A DOS extender (embedded)
>>>>&0x24	lelong	<0x50
>>>>>(&0x4c.l)	string	\xfc\xb8WATCOM
>>>>>>&0	search/8	3\xdbf\xb9 \b, 32Lite compressed
>>>(0x3c.l+0x0a)	leshort	2 for MS Windows
>>>(0x3c.l+0x0a)	leshort	3 for DOS
>>>(0x3c.l+0x0a)	leshort	4 for MS Windows (VxD)
>>>(&0x7c.l+0x26)	string	UPX \b, UPX compressed
>>>&(&0x54.l-3)	string	UNACE \b, ACE self-extracting archive
>>0x3c	lelong	>0x20000000
>>>(4.s*512)	leshort !0x014c \b, MZ for MS-DOS
>2	long	!0
>>0x18	leshort	<0x40
>>>(4.s*512)	leshort !0x014c
>>>>&(2.s-514)	string	!LE
>>>>>&-2	string	!BW \b, MZ for MS-DOS
>>>>&(2.s-514)	string	LE \b, LE
>>>>>0x240	search/0x100	DOS/4G for MS-DOS, DOS4GW DOS extender
>>>>&(2.s-514)	string	BW
>>>>>0x240	search/0x100	DOS/4G ,\b LE for MS-DOS, DOS4GW DOS extender (embedded)
>>>>>0x240	search/0x100	!DOS/4G ,\b BW collection for MS-DOS
>(4.s*512)	leshort	0x014c \b, COFF
>>(8.s*16)	string	go32stub for MS-DOS, DJGPP go32 DOS extender
>>(8.s*16)	string	emx
>>>&1	string	x for DOS, Win or OS/2, emx %s
>>&(&0x42.l-3)	byte	x 
>>>&0x26	string	UPX \b, UPX compressed
>>&0x2c	search/0xa0	.text
>>>&0x0b	lelong	<0x2000
>>>>&0	lelong	>0x6000 \b, 32lite compressed
>(8.s*16) string $WdX \b, WDos/X DOS extender
>0x35	string	\x8e\xc0\xb9\x08\x00\xf3\xa5\x4a\x75\xeb\x8e\xc3\x8e\xd8\x33\xff\xbe\x30\x00\x05 \b, aPack compressed
>0xe7	string	LH/2\ Self-Extract \b, %s
>0x1c	string	diet \b, diet compressed
>0x1c	string	LZ09 \b, LZEXE v0.90 compressed
>0x1c	string	LZ91 \b, LZEXE v0.91 compressed
>0x1c	string	tz \b, TinyProg compressed
>0x1e	string	PKLITE \b, %s compressed
>0x64	string	W\ Collis\0\0 \b, Compack compressed
>0x24	string	LHa's\ SFX \b, LHa self-extracting archive
>0x24	string	LHA's\ SFX \b, LHa self-extracting archive
>0x24	string	\ $ARX \b, ARX self-extracting archive
>0x24	string	\ $LHarc \b, LHarc self-extracting archive
>0x20	string	SFX\ by\ LARC \b, LARC self-extracting archive
>1638	string	-lh5- \b, LHa self-extracting archive v2.13S
>0x17888 string	Rar! \b, RAR self-extracting archive
>0x40	string aPKG \b, aPackage self-extracting archive
>32	string AIN
>>35	string 2	\b, AIN 2.x compressed
>>35	string <2	\b, AIN 1.x compressed
>>35	string >2	\b, AIN 1.x compressed
>28	string UC2X	\b, UCEXE compressed
>28	string WWP\	\b, WWPACK compressed
>(4.s*512)	long	x 
>>&(2.s-517)	byte	x 
>>>&0	string	PK\3\4 \b, ZIP self-extracting archive
>>>&0	string	Rar! \b, RAR self-extracting archive
>>>&0	string	=!\x11 \b, AIN 2.x self-extracting archive
>>>&0	string	=!\x12 \b, AIN 2.x self-extracting archive
>>>&0	string	=!\x17 \b, AIN 1.x self-extracting archive
>>>&0	string	=!\x18 \b, AIN 1.x self-extracting archive
>>>&7	search/400	**ACE** \b, ACE self-extracting archive
>>>&0	search/0x480	UC2SFX\ Header \b, UC2 self-extracting archive
>0x1c	string	RJSX \b, ARJ self-extracting archive
>0x20	search/0xe0	aRJsfX \b, ARJ self-extracting archive
>122	string	Windows\ self-extracting\ ZIP	\b, ZIP self-extracting archive
>(8.s*16)	search/0x20	PKSFX \b, ZIP self-extracting archive (PKZIP)
>49801	string	\x79\xff\x80\xff\x76\xff	\b, CODEC archive v3.21
>>49824	leshort	=1	\b, 1 file
>>49824	leshort	>1	\b, %u files
0	byte	0xe9	DOS executable (COM)
>0x1FE	leshort	0xAA55	\b, boot code
>6	string	SFX\ of\ LHarc	(%s)
0	belong	0xffffffff	DOS executable (device driver)
>10	string	>\x23	
>>10	string	!\x2e	
>>>17	string	<\x5B	
>>>>10	string	x	\b, name: %.8s
>10	string	<\x41	
>>12	string	>\x40	
>>>10	string	!$	
>>>>12	string	x	\b, name: %.8s
>22	string	>\x40	
>>22	string	<\x5B	
>>>23	string	<\x5B	
>>>>22	string	x	\b, name: %.8s
>76	string	\0	
>>77	string	>\x40	
>>>77	string	<\x5B	
>>>>77	string	x	\b, name: %.8s
0	byte	0x8c	DOS executable (COM)
0	byte	0xeb	DOS executable (COM)
>0x1FE	leshort	0xAA55	\b, boot code
>85	string	UPX	\b, UPX compressed
>4	string	\ $ARX	\b, ARX self-extracting archive
>4	string	\ $LHarc	\b, LHarc self-extracting archive
>0x20e	string	SFX\ by\ LARC	\b, LARC self-extracting archive
0	byte	0xb8	COM executable
>1	lelong	!0x21cd4cff	for DOS
>1	lelong	0x21cd4cff	(32-bit COMBOOT)
0	string	\x81\xfc	
>4	string	\x77\x02\xcd\x20\xb9	
>>36	string	UPX!	FREE-DOS executable (COM), UPX compressed
252	string Must\ have\ DOS\ version	DR-DOS executable (COM)
2	string	\xcd\x21	COM executable for DOS
4	string	\xcd\x21	COM executable for DOS
5	string	\xcd\x21	COM executable for DOS
7	string	\xcd\x21	
>0	byte	!0xb8	COM executable for DOS
10	string	\xcd\x21	
>5	string	!\xcd\x21	COM executable for DOS
13	string	\xcd\x21	COM executable for DOS
18	string	\xcd\x21	COM executable for MS-DOS
23	string	\xcd\x21	COM executable for MS-DOS
30	string	\xcd\x21	COM executable for MS-DOS
70	string	\xcd\x21	COM executable for DOS
0x6	search/0xa	\xfc\x57\xf3\xa5\xc3	COM executable for MS-DOS
0x6	search/0xa	\xfc\x57\xf3\xa4\xc3	COM executable for DOS
>0x18	search/0x10	\x50\xa4\xff\xd5\x73	\b, aPack compressed
0x3c	string	W\ Collis\0\0	COM executable for MS-DOS, Compack compressed
0	string	LZ	MS-DOS executable (built-in)
0	string	regf	Windows NT/XP registry file
0	string	CREG	Windows 95/98/ME registry file
0	string	SHCC3	Windows 3.1 registry file
0	string	\320\317\021\340\241\261\032\341AAFB\015\000OM\006\016\053\064\001\001\001\377	AAF legacy file using MS Structured Storage
>30	byte	9	(512B sectors)
>30	byte	12	(4kB sectors)
0	string	\320\317\021\340\241\261\032\341\001\002\001\015\000\002\000\000\006\016\053\064\003\002\001\001	AAF file using MS Structured Storage
>30	byte	9	(512B sectors)
>30	byte	12	(4kB sectors)
2080	string	Microsoft\ Word\ 6.0\ Document	%s
2080	string	Documento\ Microsoft\ Word\ 6 Spanish Microsoft Word 6 document data
2112	string	MSWordDoc	Microsoft Word document data
0	belong	0x31be0000	Microsoft Word Document
0	string	PO^Q`	Microsoft Word 6.0 Document
0	string	\376\067\0\043	Microsoft Office Document
0	string	\320\317\021\340\241\261\032\341	Microsoft Office Document
0	string	\333\245-\0\0\0	Microsoft Office Document
2080	string	Microsoft\ Excel\ 5.0\ Worksheet	%s
2080	string	Foglio\ di\ lavoro\ Microsoft\ Exce	%s
2114	string	Biff5	Microsoft Excel 5.0 Worksheet
2121	string	Biff5	Microsoft Excel 5.0 Worksheet
0	string	\x09\x04\x06\x00\x00\x00\x10\x00	Microsoft Excel Worksheet
0	belong	0x00001a00	Lotus 1-2-3
>4	belong	0x00100400	wk3 document data
>4	belong	0x02100400	wk4 document data
>4	belong	0x07800100	fm3 or fmb document data
>4	belong	0x07800000	fm3 or fmb document data
0	belong	0x00000200	Lotus 1-2-3
>4	belong	0x06040600	wk1 document data
>4	belong	0x06800200	fmt document data
0	string	?_\3\0	MS Windows Help Data
0	string	\161\250\000\000\001\002	DeIsL1.isu whatever that is
0	string	Nullsoft\ AVS\ Preset\	Winamp plug in
0	string	HyperTerminal\	hyperterm
>15	string	1.0\ --\ HyperTerminal\ data\ file	MS-windows Hyperterminal
0	string	\327\315\306\232	ms-windows metafont .wmf
0	string	\002\000\011\000	ms-windows metafont .wmf
0	string	\001\000\011\000	ms-windows metafont .wmf
0	string	\003\001\001\004\070\001\000\000	tz3 ms-works file
0	string	\003\002\001\004\070\001\000\000	tz3 ms-works file
0	string	\003\003\001\004\070\001\000\000	tz3 ms-works file
0 string \211\000\077\003\005\000\063\237\127\065\027\266\151\064\005\045\101\233\021\002 PGP sig
0 string \211\000\077\003\005\000\063\237\127\066\027\266\151\064\005\045\101\233\021\002 PGP sig
0 string \211\000\077\003\005\000\063\237\127\067\027\266\151\064\005\045\101\233\021\002 PGP sig
0 string \211\000\077\003\005\000\063\237\127\070\027\266\151\064\005\045\101\233\021\002 PGP sig
0 string \211\000\077\003\005\000\063\237\127\071\027\266\151\064\005\045\101\233\021\002 PGP sig
0 string \211\000\225\003\005\000\062\122\207\304\100\345\042 PGP sig
0	string	MDIF\032\000\010\000\000\000\372\046\100\175\001\000\001\036\001\000 MS Windows special zipped file
0	string	\164\146\115\122\012\000\000\000\001\000\000\000	MS Windows help cache
0 string	\120\115\103\103	MS Windows 3.1 group files
0	string	\114\000\000\000\001\024\002\000\000\000\000\000\300\000\000\000\000\000\000\106	MS Windows shortcut
0	string	\102\101\050\000\000\000\056\000\000\000\000\000\000\000	Icon for MS Windows
0	string	\000\000\001\000	MS Windows icon resource
>4	byte	1	- 1 icon
>4	byte	>1	- %d icons
>>6	byte	>0	\b, %dx
>>>7	byte	>0	\b%d
>>8	byte	0	\b, 256-colors
>>8	byte	>0	\b, %d-colors
0	string	PK\010\010BGI	Borland font 
>4	string	>\0	%s
0	string	pk\010\010BGI	Borland device 
>4	string	>\0	%s
9	string	\000\000\000\030\001\000\000\000 MS Windows recycled bin info
9	string	GERBILDOC	First Choice document
9	string	GERBILDB	First Choice database
9	string	GERBILCLIP	First Choice database
0	string	GERBIL	First Choice device file
9	string	RABBITGRAPH	RabbitGraph file
0	string	DCU1	Borland Delphi .DCU file
0	string	=!<spell>	MKS Spell hash list (old format)
0	string	=!<spell2>	MKS Spell hash list
0	lelong	0x08086b70	TurboC BGI file
0	lelong	0x08084b50	TurboC Font file
0	byte	0x03	DBase 3 data file
>0x04	lelong	0	(no records)
>0x04	lelong	>0	(%ld records)
0	byte	0x83	DBase 3 data file with memo(s)
>0x04	lelong	0	(no records)
>0x04	lelong	>0	(%ld records)
0	leshort	0x0006	DBase 3 index file
0	string	PMCC	Windows 3.x .GRP file
1	string	RDC-meg	MegaDots 
>8	byte	>0x2F	version %c
>9	byte	>0x2F	\b.%c file
0	lelong	0x4C
>4	lelong	0x00021401	Windows shortcut file
0	belong	0xC5D0D3C6	DOS EPS Binary File
>4	long	>0	Postscript starts at byte %d
>>8	long	>0	length %d
>>>12	long	>0	Metafile starts at byte %d
>>>>16	long	>0	length %d
>>>20	long	>0	TIFF starts at byte %d
>>>>24	long	>0	length %d
0	leshort	0x223e9f78	TNEF
0	string	ITSF\003\000\000\000\x60\000\000\000\001\000\000\000	MS Windows HtmlHelp Data
2	string	GFA-BASIC3	GFA-BASIC 3 data
#----------------------------------------------------------------------
# Microsoft Cabinet files
0	string	MSCF\0\0\0\0	Microsoft Cabinet archive data
>8	lelong	x	\b, %u bytes
>28	leshort	1	\b, 1 file
>28	leshort	>1	\b, %u files
0	string	ISc(	InstallShield Cabinet archive data
>5	byte&0xf0	=0x60	version 6,
>5	byte&0xf0	!0x60	version 4/5,
>(12.l+40)	lelong	x	%u files
0	string	MSCE\0\0\0\0	Microsoft WinCE install header
>20	lelong	0	\b, architecture-independent
>20	lelong	103	\b, Hitachi SH3
>20	lelong	104	\b, Hitachi SH4
>20	lelong	0xA11	\b, StrongARM
>20	lelong	4000	\b, MIPS R4000
>20	lelong	10003	\b, Hitachi SH3
>20	lelong	10004	\b, Hitachi SH3E
>20	lelong	10005	\b, Hitachi SH4
>20	lelong	70001	\b, ARM 7TDMI
>52	leshort	1	\b, 1 file
>52	leshort	>1	\b, %u files
>56	leshort	1	\b, 1 registry entry
>56	leshort	>1	\b, %u registry entries
0	lelong	0x4E444221	Microsoft Outlook binary email folder
0	lelong	0x00035f3f	Windows 3.x help file
0	string	Client\ UrlCache\ MMF	Microsoft Internet Explorer Cache File
>20	string	>\0	Version %s
0	string	\xCF\xAD\x12\xFE	Microsoft Outlook Express DBX File
>4	byte	=0xC5	Message database
>4	byte	=0xC6	Folder database
>4	byte	=0xC7	Accounts informations
>4	byte	=0x30	Offline database
40	ulelong 0x464D4520	Windows Enhanced Metafile (EMF) image data
>44	ulelong x	version 0x%x.
>64	ulelong >0	Description available at offset 0x%x
>>60	ulelong	>0	(length 0x%x)
>>(64.l)	lestring16 >0 Description: %15.15s
0	string	COWD	VMWare3 disk image
>12	belong	x	%d bytes
0	string	VMDK	VMware4 disk image
0	belong	0x514649fb	QEMU Copy-On-Write disk image
>4	belong	x	version %d,
>24	belong	x	size %d +
>28	belong	x	%d
0	string	QEVM	QEMU's suspend to disk image
0	string	Bochs\ Virtual\ HD\ Image	Bochs disk image,
>32	string	x	type %s,
>48	string	x	subtype %s
0	lelong	0x02468ace	Bochs Sparse disk image
#----------------------------------------------------------------------
# pdf:  file(1) magic for Portable Document Format
0	string	%PDF-	PDF document
>5	byte	x	\b, version %c
>7	byte	x	\b.%c
#----------------------------------------------------------------------
# perl:  file(1) magic for Larry Wall's perl language.
# The ``eval'' line recognizes an outrageously clever hack for USG systems.
# Keith Waclena <keith@cerberus.uchicago.edu>
# Send additions to <perl5-porters@perl.org>
0	string/b	#!\ /bin/perl	perl script text executable
0	string	eval\ "exec\ /bin/perl	perl script text
0	string/b	#!\ /usr/bin/perl	perl script text executable
0	string	eval\ "exec\ /usr/bin/perl	perl script text
0	string/b	#!\ /usr/local/bin/perl	perl script text
0	string	eval\ "exec\ /usr/local/bin/perl	perl script text executable
0	string	eval\ '(exit\ $?0)'\ &&\ eval\ 'exec	perl script text
0	string	package	Perl5 module source text
0	string/B	\=pod\n	Perl POD document
0	string/B	\n\=pod\n	Perl POD document
0	string/B	\=head1\	Perl POD document
0	string/B	\n\=head1\	Perl POD document
0	string/B	\=head2\	Perl POD document
0	string/B	\n\=head2\	Perl POD document
0	string	perl-store	perl Storable(v0.6) data
>4	byte	>0	(net-order %d)
>>4	byte	&01	(network-ordered)
>>4	byte	=3	(major 1)
>>4	byte	=2	(major 1)
0	string	pst0	perl Storable(v0.7) data
>4	byte	>0
>>4	byte	&01	(network-ordered)
>>4	byte	=5	(major 2)
>>4	byte	=4	(major 2)
>>5	byte	>0	(minor %d)
#----------------------------------------------------------------------
# pgp:  file(1) magic for Pretty Good Privacy
0	beshort	0x9900	PGP key public ring
0	beshort	0x9501	PGP key security ring
0	beshort	0x9500	PGP key security ring
0	beshort	0xa600	PGP encrypted data
0	string	-----BEGIN\040PGP	PGP armored data
>15	string	PUBLIC\040KEY\040BLOCK- public key block
>15	string	MESSAGE-	message
>15	string	SIGNED\040MESSAGE-	signed message
>15	string	PGP\040SIGNATURE-	signature
#----------------------------------------------------------------------
# python:  file(1) magic for python
# From: David Necas <yeti@physics.muni.cz>
# often the module starts with a multiline string
0	string	"""	a python script text executable
0	belong	0x994e0d0a	python 1.5/1.6 byte-compiled
0	belong	0x87c60d0a	python 2.0 byte-compiled
0	belong	0x2aeb0d0a	python 2.1 byte-compiled
0	belong	0x2ded0d0a	python 2.2 byte-compiled
0	belong	0x3bf20d0a	python 2.3 byte-compiled
0	belong	0x6df20d0a	python 2.4 byte-compiled
0	string/b	#!\ /usr/bin/python	python script text executable
#----------------------------------------------------------------------
# riff:  file(1) magic for RIFF format
# See
#	http://www.seanet.com/users/matts/riffmci/riffmci.htm
# AVI section extended by Patrik R�dman <patrik+file-magic@iki.fi>
0	string	RIFF	RIFF (little-endian) data
>8	string	PAL	\b, palette
>>16	leshort	x	\b, version %d
>>18	leshort	x	\b, %d entries
>8	string	RDIB	\b, device-independent bitmap
>>16	string	BM	
>>>30	leshort	12	\b, OS/2 1.x format
>>>>34	leshort	x	\b, %d x
>>>>36	leshort	x	%d
>>>30	leshort	64	\b, OS/2 2.x format
>>>>34	leshort	x	\b, %d x
>>>>36	leshort	x	%d
>>>30	leshort	40	\b, Windows 3.x format
>>>>34	lelong	x	\b, %d x
>>>>38	lelong	x	%d x
>>>>44	leshort	x	%d
>8	string	RMID	\b, MIDI
>8	string	RMMP	\b, multimedia movie
>8	string	WAVE	\b, WAVE audio
>>20	leshort	1	\b, Microsoft PCM
>>>34	leshort	>0	\b, %d bit
>>20	leshort	2	\b, Microsoft ADPCM
>>20	leshort	6	\b, ITU G.711 A-law
>>20	leshort	7	\b, ITU G.711 mu-law
>>20	leshort	17	\b, IMA ADPCM
>>20	leshort	20	\b, ITU G.723 ADPCM (Yamaha)
>>20	leshort	49	\b, GSM 6.10
>>20	leshort	64	\b, ITU G.721 ADPCM
>>20	leshort	80	\b, MPEG
>>20	leshort	85	\b, MPEG Layer 3
>>22	leshort	=1	\b, mono
>>22	leshort	=2	\b, stereo
>>22	leshort	>2	\b, %d channels
>>24	lelong	>0	%d Hz
>8	string	CDRA	\b, Corel Draw Picture
>8	string	AVI\040	\b, AVI
>>12	string	LIST
>>>20	string	hdrlavih
>>>>&36 lelong	x	\b, %lu x
>>>>&40 lelong	x	%lu,
>>>>&4	lelong	>1000000	<1 fps,
>>>>&4	lelong	1000000	1.00 fps,
>>>>&4	lelong	500000	2.00 fps,
>>>>&4	lelong	333333	3.00 fps,
>>>>&4	lelong	250000	4.00 fps,
>>>>&4	lelong	200000	5.00 fps,
>>>>&4	lelong	166667	6.00 fps,
>>>>&4	lelong	142857	7.00 fps,
>>>>&4	lelong	125000	8.00 fps,
>>>>&4	lelong	111111	9.00 fps,
>>>>&4	lelong	100000	10.00 fps,
>>>>&4	lelong	<101010
>>>>>&-4	lelong	>99010
>>>>>>&-4	lelong	!100000	~10 fps,
>>>>&4	lelong	83333	12.00 fps,
>>>>&4	lelong	<84034
>>>>>&-4	lelong	>82645
>>>>>>&-4	lelong	!83333	~12 fps,
>>>>&4	lelong	66667	15.00 fps,
>>>>&4	lelong	<67114
>>>>>&-4	lelong	>66225
>>>>>>&-4	lelong	!66667	~15 fps,
>>>>&4	lelong	50000	20.00 fps,
>>>>&4	lelong	41708	23.98 fps,
>>>>&4	lelong	41667	24.00 fps,
>>>>&4	lelong	<41841
>>>>>&-4	lelong	>41494
>>>>>>&-4	lelong	!41708
>>>>>>>&-4	lelong	!41667	~24 fps,
>>>>&4	lelong	40000	25.00 fps,
>>>>&4	lelong	<40161
>>>>>&-4	lelong	>39841
>>>>>>&-4	lelong	!40000	~25 fps,
>>>>&4	lelong	33367	29.97 fps,
>>>>&4	lelong	33333	30.00 fps,
>>>>&4	lelong	<33445
>>>>>&-4	lelong	>33223
>>>>>>&-4	lelong	!33367
>>>>>>>&-4	lelong	!33333	~30 fps,
>>>>&4	lelong	<32224	>30 fps,
>>>88	string	LIST
>>>>96	string	strlstrh
>>>>>108	string	vids	video:
>>>>>>&0	lelong	0	uncompressed
>>>>>>(104.l+108)	string	strf
>>>>>>>(104.l+132)	lelong	1	RLE 8bpp
>>>>>>>(104.l+132)	string/c	cvid	Cinepak
>>>>>>>(104.l+132)	string/c	i263	Intel I.263
>>>>>>>(104.l+132)	string/c	iv32	Indeo 3.2
>>>>>>>(104.l+132)	string/c	iv41	Indeo 4.1
>>>>>>>(104.l+132)	string/c	iv50	Indeo 5.0
>>>>>>>(104.l+132)	string/c	mp42	Microsoft MPEG-4 v2
>>>>>>>(104.l+132)	string/c	mp43	Microsoft MPEG-4 v3
>>>>>>>(104.l+132)	string/c	mjpg	Motion JPEG
>>>>>>>(104.l+132)	string/c	div3	DivX 3
>>>>>>>>112	string/c	div3	Low-Motion
>>>>>>>>112	string/c	div4	Fast-Motion
>>>>>>>(104.l+132)	string/c	divx	DivX 4
>>>>>>>(104.l+132)	string/c	dx50	DivX 5
>>>>>>>(104.l+132)	string/c	xvid	XviD
>>>>>>>(104.l+132)	string/c	h264	X.264
>>>>>>>(104.l+132)	lelong	0
>>>>(92.l+96)	string	LIST
>>>>>(92.l+104) string	strlstrh
>>>>>>(92.l+116)	string	auds	\b, audio:
>>>>>>>(92.l+172)	string	strf
>>>>>>>>(92.l+180)	leshort 0x0001	uncompressed PCM
>>>>>>>>(92.l+180)	leshort 0x0002	ADPCM
>>>>>>>>(92.l+180)	leshort 0x0055	MPEG-1 Layer 3
>>>>>>>>(92.l+180)	leshort 0x2000	Dolby AC3
>>>>>>>>(92.l+180)	leshort 0x0161	DivX
>>>>>>>>(92.l+182)	leshort 1	(mono,
>>>>>>>>(92.l+182)	leshort 2	(stereo,
>>>>>>>>(92.l+182)	leshort >2	(%d channels,
>>>>>>>>(92.l+184)	lelong	x	%d Hz)
>>>>>>>(92.l+180)	string	strf
>>>>>>>>(92.l+188)	leshort 0x0001	uncompressed PCM
>>>>>>>>(92.l+188)	leshort 0x0002	ADPCM
>>>>>>>>(92.l+188)	leshort 0x0055	MPEG-1 Layer 3
>>>>>>>>(92.l+188)	leshort 0x2000	Dolby AC3
>>>>>>>>(92.l+188)	leshort 0x0161	DivX
>>>>>>>>(92.l+190)	leshort 1	(mono,
>>>>>>>>(92.l+190)	leshort 2	(stereo,
>>>>>>>>(92.l+190)	leshort >2	(%d channels,
>>>>>>>>(92.l+192)	lelong	x	%d Hz)
>8	string	ACON	\b, animated cursor
>8	string	sfbk	SoundFont/Bank
>8	string	CDXA	\b, wrapped MPEG-1 (CDXA)
>8	string	4XMV	\b, 4X Movie file 
0	string	RIFX	RIFF (big-endian) data
>8	string	PAL	\b, palette
>>16	beshort	x	\b, version %d
>>18	beshort	x	\b, %d entries
>8	string	RDIB	\b, device-independent bitmap
>>16	string	BM	
>>>30	beshort	12	\b, OS/2 1.x format
>>>>34	beshort	x	\b, %d x
>>>>36	beshort	x	%d
>>>30	beshort	64	\b, OS/2 2.x format
>>>>34	beshort	x	\b, %d x
>>>>36	beshort	x	%d
>>>30	beshort	40	\b, Windows 3.x format
>>>>34	belong	x	\b, %d x
>>>>38	belong	x	%d x
>>>>44	beshort	x	%d
>8	string	RMID	\b, MIDI
>8	string	RMMP	\b, multimedia movie
>8	string	WAVE	\b, WAVE audio
>>20	leshort	1	\b, Microsoft PCM
>>>34	leshort	>0	\b, %d bit
>>22	beshort	=1	\b, mono
>>22	beshort	=2	\b, stereo
>>22	beshort	>2	\b, %d channels
>>24	belong	>0	%d Hz
>8	string	CDRA	\b, Corel Draw Picture
>8	string	AVI\040	\b, AVI
>8	string	ACON	\b, animated cursor
>8	string	NIFF	\b, Notation Interchange File Format
>8	string	sfbk	SoundFont/Bank
#----------------------------------------------------------------------
# RPM: file(1) magic for Red Hat Packages   Erik Troan (ewt@redhat.com)
0	beshort	0xedab
>2	beshort	0xeedb	RPM
>>4	byte	x	v%d
>>6	beshort	0	bin
>>6	beshort	1	src
>>8	beshort	1	i386
>>8	beshort	2	Alpha
>>8	beshort	3	Sparc
>>8	beshort	4	MIPS
>>8	beshort	5	PowerPC
>>8	beshort	6	68000
>>8	beshort	7	SGI
>>8	beshort	8	RS6000
>>8	beshort	9	IA64
>>8	beshort	10	Sparc64
>>8	beshort	11	MIPSel
>>8	beshort	12	ARM
>>10	string	x	%s
#----------------------------------------------------------------------
# rtf:	file(1) magic for Rich Text Format (RTF)
# Duncan P. Simpson, D.P.Simpson@dcs.warwick.ac.uk
0	string	{\\rtf	Rich Text Format data,
>5	byte	x	version %c,
>6	string	\\ansi	ANSI
>6	string	\\mac	Apple Macintosh
>6	string	\\pc	IBM PC, code page 437
>6	string	\\pca	IBM PS/2, code page 850
#----------------------------------------------------------------------
# sgml:  file(1) magic for Standard Generalized Markup Language
# HyperText Markup Language (HTML) is an SGML document type,
# from Daniel Quinlan (quinlan@yggdrasil.com)
# adapted to string extenstions by Anthon van der Neut <anthon@mnt.org)
0	string/cB	\<!DOCTYPE\ html	HTML document text
0	string/cb	\<head	HTML document text
0	string/cb	\<title	HTML document text
0	string/cb	\<html	HTML document text
0	string/cb	\<?xml	XML document text
0	string	\<?xml\ version "	XML
0	string	\<?xml\ version="	XML
>15	string	>\0	%.3s document text
>>23	string	\<xsl:stylesheet	(XSL stylesheet)
>>24	string	\<xsl:stylesheet	(XSL stylesheet)
0	string/b	\<?xml	XML document text
0	string/cb	\<?xml	broken XML document text
0	string \x3C\x00\x3F\x00\x78\x00\x6D\x00\x6C\x00 XML document text (little endian)
0	string \xFF\xFE\x3C\x00\x3F\x00\x78\x00\x6D\x00\x6C\x00 XML document text (little endian with byte order mark)
0	string/cb	\<!doctype	exported SGML document text
0	string/cb	\<!subdoc	exported SGML subdocument text
0	string/cb	\<!--	exported SGML document text
0	string	#\ HTTP\ Cookie\ File	Web browser cookie text
0	string	#\ Netscape\ HTTP\ Cookie\ File	Netscape cookie text
0	string	#\ KDE\ Cookie\ File	Konqueror cookie text
#----------------------------------------------------------------------
# uuencode:  file(1) magic for ASCII-encoded files
0	string	begin\040	uuencoded or xxencoded text
0	string	xbtoa\ Begin	btoa'd text
0	string	$\012ship	ship'd binary text
0	string	Decode\ the\ following\ with\ bdeco	bencoded News text
11	string	must\ be\ converted\ with\ BinHex	BinHex binary text
>41	string	x	\b, version %.3s
